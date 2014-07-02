Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaGBQyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51277 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaGBQyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 41/48] staging: rtl8188eu: rtw_cmd.h: Remove unused structures
Date: Wed,  2 Jul 2014 22:17:37 +0530
Message-Id: <1404319664-8327-41-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |  102 ---------------------------
 1 file changed, 102 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 8e8092b..8b0712f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -245,108 +245,6 @@ struct setstapwrstate_parm {
 };
 
 /*
-Caller Mode: Any
-
-Notes: To setup the basic rate of RTL8711
-
-Command Mode
-
-*/
-struct	setbasicrate_parm {
-	u8	basicrates[NumRates];
-};
-
-/*
-Caller Mode: Any
-
-Notes: To read the current basic rate
-
-Command-Rsp Mode
-
-*/
-struct getbasicrate_parm {
-	u32 rsvd;
-};
-
-/*
-Caller Mode: Any
-
-Notes: To setup the data rate of RTL8711
-
-Command Mode
-
-*/
-struct setdatarate_parm {
-	u8	mac_id;
-	u8	datarates[NumRates];
-};
-
-/*
-Caller Mode: Any
-
-Notes: To read the current data rate
-
-Command-Rsp Mode
-
-*/
-struct getdatarate_parm {
-	u32 rsvd;
-
-};
-struct getdatarate_rsp {
-	u8 datarates[NumRates];
-};
-
-/*
-Caller Mode: Any
-AP: AP can use the info for the contents of beacon frame
-Infra: STA can use the info when sitesurveying
-Ad-HoC(M): Like AP
-Ad-HoC(C): Like STA
-
-Notes: To set the phy capability of the NIC
-
-Command Mode
-
-*/
-
-struct	setphyinfo_parm {
-	struct regulatory_class class_sets[NUM_REGULATORYS];
-	u8	status;
-};
-
-struct	getphyinfo_parm {
-	u32 rsvd;
-};
-
-/*
-Caller Mode: Any
-
-Notes: To set the channel/modem/band
-This command will be used when channel/modem/band is changed.
-
-Command Mode
-
-*/
-struct	setphy_parm {
-	u8	rfchannel;
-	u8	modem;
-};
-
-/*
-Caller Mode: Any
-
-Notes: To get the current setting of channel/modem/band
-
-Command-Rsp Mode
-
-*/
-struct	getphy_parm {
-	u32 rsvd;
-
-};
-
-/*
 	Notes: This command is used for H2C/C2H loopback testing
 
 	mac[0] == 0
-- 
1.7.10.4

