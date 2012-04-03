/**
 * Dreamsocket
 * 
 * Copyright 2011 Dreamsocket.
 * All Rights Reserved. 
 *
 * This software (the "Software") is the property of Dreamsocket and is protected by U.S. and
 * international intellectual property laws. No license is granted with respect to the
 * software and users may not, among other things, reproduce, prepare derivative works
 * of, modify, distribute, sublicense, reverse engineer, disassemble, remove, decompile,
 * or make any modifications of the Software without written permission from Dreamsocket.
 * Further, Dreamsocket does not authorize any user to remove or alter any trademark, logo,
 * copyright or other proprietary notice, legend, symbol, or label in the Software.
 * This notice is not intended to, and shall not, limit any rights Dreamsocket has under
 * applicable law.
 * 
 */
package com.dreamsocket.messaging.p2p
{
	import com.dreamsocket.events.ConnectionEvent;
	
	import com.dreamsocket.messaging.IChannel;
	import com.dreamsocket.messaging.Message;
	import com.dreamsocket.messaging.MessageEvent;
	import com.dreamsocket.net.NetGroupStatusCodes;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetGroup;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	
	
		
	public class P2PChannel extends EventDispatcher implements IChannel
	{
		protected var m_appID:String;
		protected var m_channelID:String;
		protected var m_connected:Boolean;
		protected var m_connecting:Boolean;
		protected var m_group:NetGroup;
		protected var m_local:Boolean;
		protected var m_spec:GroupSpecifier;
		protected var m_registeredMessages:Object;
		protected var m_service:P2PConnection;

		
		public function P2PChannel(p_service:P2PConnection, p_appID:String, p_channelID:String, p_local:Boolean = true)
		{
			super();
			
			this.m_appID = p_appID;
			this.m_channelID = p_channelID;
			this.m_local = p_local;
			
			// artificial delay because messages weren't getting sent
			this.m_service = p_service;
			this.m_service.addEventListener(ConnectionEvent.CONNECT_CLOSED, this.onServiceClosed);
			this.m_service.addEventListener(ConnectionEvent.CONNECT_FAILED, this.onServiceFailed);
			this.m_service.addEventListener(ConnectionEvent.CONNECT_SUCCEEDED, this.onServiceConnected);
			this.m_service.connection.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusReceived);

			this.m_registeredMessages = {};
			this.register(Message.TYPE, [Message]);
			
			this.createSpec();
		}
		
		
		public function get appID():String
		{
			return this.m_appID;
		}		
		
		
		public function get channelID():String
		{
			return this.m_channelID;
		}
		
		public function get peerID():String
		{
			return this.m_service.connected ? this.m_service.connection.nearID : null;
		}
		
		
		public function get connected():Boolean
		{
			return this.m_connected;
		}
		
		
		public function get connecting():Boolean
		{
			return this.m_connecting;
		}		
		
		
		public function get group():NetGroup
		{
			return this.m_group;
		}
		
		
		public function get specifier():GroupSpecifier
		{
			return this.m_spec;
		}
		
		
		public function close():void
		{
			if(this.m_group && (this.m_connected || this.m_connecting))
			{
				this.m_connected = false;
				this.m_connecting = false;
				this.m_group.close();

				this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_CLOSED));
			}
		}
		
		
		public function connect():void
		{
			if(this.m_connecting || this.m_connected) return;
			
			trace("connecting");
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_REQUESTED));
			
			if(!this.m_service.connected) 
			{
				this.m_connecting = true;
				this.m_service.connect();
			}
			else if(!this.m_connected)
			{
				this.m_connecting = true;
				this.doConnect();
			}
		}
		
		
		public function send(p_message:Message):void
		{
			if(!this.m_connected) return;
			
			
			trace("send " + p_message.type);
			p_message.senderPeerID = this.m_service.connection.nearID;
			p_message.timestamp = new Date().valueOf();
			
			this.m_group.post(p_message);
		}
		
		
		public function register(p_type:String, p_dependencies:Array = null):void
		{
			this.m_registeredMessages[p_type] = true;
			this.registerDependencies(p_dependencies);
		}
		
				
		public function unregister(p_type:String):void
		{
			delete(this.m_registeredMessages[p_type]);
		}
			
		
		protected function doConnect():void
		{	
			trace("do connect " + this.m_appID + "/" + this.m_channelID);
			this.m_group = new NetGroup(this.m_service.connection, this.m_spec.groupspecWithAuthorizations());
			this.m_group.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusReceived);		
		}
		
		
		protected function createSpec():void
		{
			if(!this.m_appID || !this.m_channelID) return;
			
			this.m_spec = new GroupSpecifier(this.m_appID + "/" + this.m_channelID);
			this.m_spec.postingEnabled = true;
			
			if(this.m_local)
			{	// IP based profile
				this.m_spec.ipMulticastMemberUpdatesEnabled = true;
				this.m_spec.addIPMulticastAddress("225.225.0.1:30303");					
			}
			else
			{	// server based profile
				this.m_spec.serverChannelEnabled = true;
			}			
		}
		
		protected function dispatchMessage(p_value:Message):void
		{
			if(p_value && this.m_registeredMessages[p_value.type] && this.hasEventListener(p_value.type))
				this.dispatchEvent(new MessageEvent(p_value.type, p_value));
		}
		
		
		protected function registerClass(p_class:Class):void
		{
			registerClassAlias(getQualifiedClassName(p_class).replace("::", "."), p_class);
		}
		
		
		protected function registerDependencies(p_classes:Array):void
		{
			if(!p_classes) return;
			
			var i:uint = p_classes.length;
			while(i--)
			{
				this.registerClass(p_classes[i] as Class);
			}
		}
		
		
		protected function setConnected():void
		{
			this.m_connecting = false;
			this.m_connected = true;
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_SUCCEEDED, NetGroupStatusCodes.NETGROUP_CONNECT_SUCCESS));			
		}


		protected function onServiceClosed(p_event:ConnectionEvent):void
		{
			this.m_connecting = false;
			
			if(this.m_connected)
			{
				this.m_connected = false;
				this.dispatchEvent(p_event);
			}
		}
		
		
		protected function onServiceFailed(p_event:ConnectionEvent):void
		{
			
			trace("connector failed");
			this.m_connecting = false;
			
			if(this.m_connecting)
				this.dispatchEvent(p_event);	
		}
		
		
		protected function onNetStatusReceived(p_event:NetStatusEvent):void
		{
			var code:String = p_event.info.code;
			
			trace("netStatus " + code);
			if(this.hasEventListener(p_event.type))
				this.dispatchEvent(p_event);

			switch(code)
			{
				case NetGroupStatusCodes.NETGROUP_CONNECT_FAILED:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_FAILED, code));
					break;
				case NetGroupStatusCodes.NETGROUP_CONNECT_REJECTED:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_FAILED, code));
					break;
				case NetGroupStatusCodes.NETGROUP_CONNECT_SUCCESS:
					if(p_event.info.group && p_event.info.group == this.m_group)
					{
						this.setConnected();
					}
					break;
				case NetGroupStatusCodes.NETGROUP_POSTING_NOTIFY:
					if(p_event.info.message as Message)
						this.dispatchMessage(p_event.info.message as Message);
					break;
			}
		}
		
		
		protected function onServiceConnected(p_event:ConnectionEvent):void
		{
			trace("connector connected");
			this.doConnect();
		}
	}
}
