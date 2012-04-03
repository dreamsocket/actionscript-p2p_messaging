/**
 * Dreamsocket
 * 
 * Copyright 2010 Dreamsocket.
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
 
package com.dreamsocket.events
{
	import flash.events.Event;
	
		
			
	public class ConnectionEvent extends Event
	{
		public static const CONNECT_CLOSED:String = "connectClosed";
		public static const CONNECT_FAILED:String = "connectFailed";
		public static const CONNECT_REQUESTED:String = "connectRequested";
		public static const CONNECT_SUCCEEDED:String = "connectSucceeded";
		
		protected var m_code:String;
		
		public function ConnectionEvent(p_type:String, p_code:String = null, p_bubbles:Boolean = false, p_cancelable:Boolean = false)
		{
			super(p_type, p_bubbles, p_cancelable);
			
			this.m_code = p_code;
		}
		
		
		public function get code():String
		{
			return this.m_code;
		}
		
			
		override public function clone():Event
		{
			return new ConnectionEvent(this.type, this.code, this.bubbles, this.cancelable);
		}
		
		
		override public function toString():String
		{
			return this.formatToString("ConnectionEvent", "type", "code", "bubbles",  "cancelable");	
		}		
	}
}
