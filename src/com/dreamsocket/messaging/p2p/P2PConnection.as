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
	import com.dreamsocket.net.NetConnectionStatusCodes;
	
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	
	
	
	
		
	public class P2PConnection extends EventDispatcher
	{
		protected var m_connection:NetConnection;
		protected var m_connecting:Boolean;
		protected var m_uri:String;

		
		public function P2PConnection(p_uri:String)
		{
			super();
			
			this.m_uri = p_uri;
			
			this.m_connection = new NetConnection();
			this.m_connection.maxPeerConnections = 50;
			this.m_connection.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusReceived);
		}
		
		
		public function get connected():Boolean
		{
			return this.m_connection.connected;
		}
		
		
		public function get connection():NetConnection
		{
			return this.m_connection;
		}


		public function get connecting():Boolean
		{
			return this.m_connecting;
		}
		
		
		public function get uri():String
		{
			return this.m_uri;
		}
		
		
		public function close():void
		{
			this.m_connecting = false;
			try
			{
				this.m_connection.close();
			}
			catch(error:Error){}
		}
		
		
		public function connect():void
		{
			if(!this.m_connection.connected && !this.m_connecting)
			{
				
				trace("max netConnections " + this.m_connection.maxPeerConnections);
				trace("connecting to NetConnection");
				this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_REQUESTED));
				this.m_connecting = true;
				this.m_connection.connect(this.m_uri);
			}
		}
		
	
		protected function onNetStatusReceived(p_event:NetStatusEvent):void
		{
			var code:String = p_event.info.code;

			trace"netStatus " + code);
			switch(code)
			{
				case NetConnectionStatusCodes.NETCONNECTION_CONNECT_CLOSED:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_CLOSED, code));
					break;	
				case NetConnectionStatusCodes.NETCONNECTION_CONNECT_FAILED:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_FAILED, code));
					break;
				case NetConnectionStatusCodes.NETCONNECTION_CONNECT_REJECTED:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_FAILED, code));
					break;
				case NetConnectionStatusCodes.NETCONNECTION_CONNECT_SUCCESS:
					this.m_connecting = false;
					this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECT_SUCCEEDED, code));
					break;									
			}
		}
	}
}
