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
package com.dreamsocket.net
{
    public class NetConnectionStatusCodes 
    {
        public static const NETCONNECTION_CALL_BADVERSION:String = "NetConnection.Call.BadVersion";
        public static const NETCONNECTION_CALL_FAILED:String = "NetConnection.Call.Failed";
        public static const NETCONNECTION_CALL_PROHIBITED:String = "NetConnection.Call.Prohibited";
      
        public static const NETCONNECTION_CONNECT_APPSHUTDOWN:String = "NetConnection.Connect.AppShutdown";
        public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
        public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";
        public static const NETCONNECTION_CONNECT_IDLETIMEOUT:String = "NetConnection.Connect.IdleTimeOut";	
		public static const NETCONNECTION_CONNECT_INVALIDAPP:String = "NetConnection.Connect.InvalidApp";	
		public static const NETCONNECTION_CONNECT_NETWORKCHANGE:String = "NetConnection.Connect.NetworkChange";
        public static const NETCONNECTION_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
        public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
        

    }
}
