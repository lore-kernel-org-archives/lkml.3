Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3HOVVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:21:35 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64824 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3HOVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:21:34 -0400
Date: Thu, 15 Aug 2013 22:21:29 +0100 (IST)
From: "paulmcquad@gmail.com" <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
Message-ID: <alpine.DEB.2.02.1308152213010.7299@paul87-DT2110>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__Function__ gets replaced with __func__

Signed-Off-By: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/bcm/DDRInit.c |   54 
++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 8c696b6..f5eda96 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -828,13 +828,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 				retval= rdmalt(Adapter,(UINT)0x0f000830, 
&uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, 
RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, 
RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 				uiResetValue |= 0x44;
 				retval = wrmalt(Adapter,(UINT)0x0f000830, 
&uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, 
WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, 
RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 		}
@@ -972,7 +972,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		}
 		retval = wrmalt(Adapter, psDDRSetting->ulRegAddress, 
&value, sizeof(value));
 		if(STATUS_SUCCESS != retval) {
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 
0,"%s:%d\n", __FUNCTION__, __LINE__);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, 
"%s:%d\n", __func__, __LINE__);
 			break;
 		}
 
@@ -992,25 +992,25 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			uiResetValue = 0x01010001;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x00040020;
 			retval = wrmalt(Adapter, (UINT)0x0F007094, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01020101;
 			retval = wrmalt(Adapter, (UINT)0x0F00701c, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01010000;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1026,34 +1026,34 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 
RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 
RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x132296;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1062,34 +1062,34 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x6003229a;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, 
&uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, 
DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1235,28 +1235,28 @@ int download_ddr_settings(struct bcm_mini_adapter 
*Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, 
sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", 
__FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", 
__func__, __LINE__);
 
 		return retval;
 	}
-	ul_ddr_setting_load_addr+=sizeof(ULONG);
+	ul_ddr_setting_load_addr += sizeof(ULONG);
 	/*signature */
 	value =(0x1d1e0dd0);
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, 
sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", 
__FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", 
__func__, __LINE__);
 		return retval;
 	}
 
-	ul_ddr_setting_load_addr+=sizeof(ULONG);
+	ul_ddr_setting_load_addr += sizeof(ULONG);
 	RegCount*=(sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
 
 	while(RegCount && !retval)
 	{
 		value = psDDRSetting->ulRegAddress ;
 		retval = wrmalt( Adapter, ul_ddr_setting_load_addr, 
&value, sizeof(value));
-		ul_ddr_setting_load_addr+=sizeof(ULONG);
+		ul_ddr_setting_load_addr += sizeof(ULONG);
 		if(!retval)
 		{
 			if(bOverrideSelfRefresh && 
(psDDRSetting->ulRegAddress == 0x0F007018))
@@ -1264,7 +1264,7 @@ int download_ddr_settings(struct bcm_mini_adapter 
*Adapter)
 				value = (psDDRSetting->ulRegValue 
|(1<<8));
 				if(STATUS_SUCCESS != wrmalt(Adapter, 
ul_ddr_setting_load_addr,
 						&value, sizeof(value))){
-					
BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, 
__LINE__);
+					BCM_DEBUG_PRINT(Adapter, 
DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
 			}
@@ -1274,12 +1274,12 @@ int download_ddr_settings(struct bcm_mini_adapter 
*Adapter)
 
 				if(STATUS_SUCCESS != wrmalt(Adapter, 
ul_ddr_setting_load_addr ,
 							&value, 
sizeof(value))){
-					
BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, 
__LINE__);
+					BCM_DEBUG_PRINT(Adapter, 
DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
 			}
 		}
-		ul_ddr_setting_load_addr+=sizeof(ULONG);
+		ul_ddr_setting_load_addr += sizeof(ULONG);
 		RegCount--;
 		psDDRSetting++;
 	}
-- 
1.7.10.4

