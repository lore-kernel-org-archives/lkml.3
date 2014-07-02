Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaGBQwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:15 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46860 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbaGBQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/48] staging: rtl8188eu: rtw_cmd.h: Remove unused macros
Date: Wed,  2 Jul 2014 22:17:19 +0530
Message-Id: <1404319664-8327-23-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 1e3161e..0803742 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -24,16 +24,11 @@
 #include <rtw_rf.h>
 #include <rtw_led.h>
 
-#define C2H_MEM_SZ (16*1024)
-
 #include <osdep_service.h>
 #include <ieee80211.h> /*  <ieee80211/ieee80211.h> */
 
-#define FREE_CMDOBJ_SZ	128
-
 #define MAX_CMDSZ	1024
 #define MAX_RSPSZ	512
-#define MAX_EVTSZ	1024
 
 #define CMDBUFF_ALIGN_SZ 512
 
@@ -707,16 +702,11 @@ Result:
 
 */
 
-#define H2C_RSP_OFFSET		512
-
 #define H2C_SUCCESS		0x00
 #define H2C_SUCCESS_RSP		0x01
-#define H2C_DUPLICATED		0x02
 #define H2C_DROPPED		0x03
 #define H2C_PARAMETERS_ERROR	0x04
 #define H2C_REJECTED		0x05
-#define H2C_CMD_OVERFLOW	0x06
-#define H2C_RESERVED		0x07
 
 u8 rtw_sitesurvey_cmd(struct adapter *padapter, struct ndis_802_11_ssid *ssid,
 		      int ssid_num, struct rtw_ieee80211_channel *ch,
@@ -841,11 +831,6 @@ enum rtw_h2c_cmd {
 	MAX_H2CCMD
 };
 
-#define _GetBBReg_CMD_		_Read_BBREG_CMD_
-#define _SetBBReg_CMD_		_Write_BBREG_CMD_
-#define _GetRFReg_CMD_		_Read_RFREG_CMD_
-#define _SetRFReg_CMD_		_Write_RFREG_CMD_
-
 #ifdef _RTW_CMD_C_
 static struct _cmd_callback	rtw_cmd_callback[] = {
 	{GEN_CMD_CODE(_Read_MACREG), NULL}, /*0*/
-- 
1.7.10.4

