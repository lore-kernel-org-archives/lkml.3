Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaEZQIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:08:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59090 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:08:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/24] staging: rtl8188eu: Remove unused enum odm_h2c_cmd.
Date: Mon, 26 May 2014 21:35:38 +0530
Message-Id: <1401120339-23667-23-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index e29ac79..dc6b1c2 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -21,10 +21,4 @@
 #ifndef	__ODM_INTERFACE_H__
 #define __ODM_INTERFACE_H__
 
-enum odm_h2c_cmd {
-	ODM_H2C_RSSI_REPORT = 0,
-	ODM_H2C_PSD_RESULT = 1,
-	ODM_H2C_PathDiv = 2,
-	ODM_MAX_H2CCMD
-};
 #endif	/*  __ODM_INTERFACE_H__ */
-- 
1.7.10.4

