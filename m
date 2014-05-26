Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaEZQHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:18 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39461 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/24] staging: rtl8188eu: Remove unused structure "rtl8192cd_priv"
Date: Mon, 26 May 2014 21:35:28 +0530
Message-Id: <1401120339-23667-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm.h b/drivers/staging/rtl8188eu/include/odm.h
index 9d1a79c..e83812f 100644
--- a/drivers/staging/rtl8188eu/include/odm.h
+++ b/drivers/staging/rtl8188eu/include/odm.h
@@ -90,14 +90,6 @@
 #define ANTTESTA		0x01	/* Ant A will be Testing */
 #define ANTTESTB		0x02	/* Ant B will be testing */
 
-/*  structure and define */
-
-/*  Add for AP/ADSLpseudo DM structuer requirement. */
-/*  We need to remove to other position??? */
-struct rtl8192cd_priv {
-	u8		temp;
-};
-
 struct rtw_dig {
 	u8		Dig_Enable_Flag;
 	u8		Dig_Ext_Port_Stage;
-- 
1.7.10.4

