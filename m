Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3HGRMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:12:00 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61429 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3HGRL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:11:58 -0400
Message-ID: <52027FDA.3020707@gmail.com>
Date: Wed, 07 Aug 2013 18:11:54 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
Content-Type: multipart/mixed;
 boundary="------------000807060005070205080609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000807060005070205080609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------000807060005070205080609
Content-Type: text/x-patch;
 name="0001-Staging-BCM-DDRInit.c-Replacing-__FUNCTION__.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Staging-BCM-DDRInit.c-Replacing-__FUNCTION__.patch"

>From 5b6fbb6496ddc4e428f5dd0950b0617faed6596b Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Wed, 7 Aug 2013 16:21:16 +0100
Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__

__func__ replaces __Function__.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/bcm/DDRInit.c |   58 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 8c696b6..73ddf01 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -828,13 +828,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 				retval= rdmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 				uiResetValue |= 0x44;
 				retval = wrmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __func__, __LINE__);
 					return retval;
 				}
 		}
@@ -972,7 +972,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		}
 		retval = wrmalt(Adapter, psDDRSetting->ulRegAddress, &value, sizeof(value));
 		if(STATUS_SUCCESS != retval) {
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 			break;
 		}
 
@@ -992,25 +992,25 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			uiResetValue = 0x01010001;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x00040020;
 			retval = wrmalt(Adapter, (UINT)0x0F007094, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01020101;
 			retval = wrmalt(Adapter, (UINT)0x0F00701c, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01010000;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1026,34 +1026,34 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x132296;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1062,34 +1062,34 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x6003229a;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1235,7 +1235,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 
 		return retval;
 	}
@@ -1245,7 +1245,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 		return retval;
 	}
 
@@ -1259,27 +1259,25 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		ul_ddr_setting_load_addr+=sizeof(ULONG);
 		if(!retval)
 		{
-			if(bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018))
-			{
+			if (bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018)) {
 				value = (psDDRSetting->ulRegValue |(1<<8));
 				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
 						&value, sizeof(value))){
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
-					break;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
+				break;
 				}
- 			}
-			else
-			{
+				value = uiClockSetting;
+			else
+				value =  psDDRSetting->ulRegValue;
+
 				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
 							&value, sizeof(value))){
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
-					break;
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
+				break;
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


--------------000807060005070205080609--
