Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaFAMS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:18:56 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58974 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaFAMSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:18:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/26] staging: rtl8188eu: Remove unused enum
Date: Sun,  1 Jun 2014 17:46:37 +0530
Message-Id: <1401625013-11208-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 8cbdab5..d38f861 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -54,13 +54,6 @@
 #include <rtw_mp.h>
 #include <rtw_br_ext.h>
 
-enum _NIC_VERSION {
-	RTL8711_NIC,
-	RTL8712_NIC,
-	RTL8713_NIC,
-	RTL8716_NIC
-};
-
 #define SPEC_DEV_ID_NONE		BIT(0)
 #define SPEC_DEV_ID_DISABLE_HT		BIT(1)
 #define SPEC_DEV_ID_ENABLE_PS		BIT(2)
-- 
1.7.10.4

