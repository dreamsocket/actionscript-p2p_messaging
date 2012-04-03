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
 
package com.dreamsocket.messaging
{
	import flash.events.Event;
	

	public class MessageEvent extends Event
	{
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		
		protected var m_message:Message;
		
		
		public function MessageEvent(p_type:String, p_message:Message, p_bubbles:Boolean = true, p_cancelable:Boolean = false)
		{
			super(p_type, p_bubbles, p_cancelable);
			
			this.m_message = p_message;
		}
		
		
		public function get message():Message
		{
			return this.m_message;
		}
		
		
		override public function clone():Event
		{
			return new MessageEvent(this.type, this.message, this.bubbles, this.cancelable);
		}
		
		
		override public function toString():String
		{
			return this.formatToString("MessageEvent", "type", "bubbles",  "cancelable");	
		}		
	}
}
