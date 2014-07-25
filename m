Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbaGYQWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:22:53 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48738 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaGYQWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:22:52 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from hostap.h
Date: Fri, 25 Jul 2014 19:22:35 +0300
Message-Id: <1406305355-32011-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from hostap.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/hostap.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.h b/drivers/staging/vt6655/hostap.h
index f1a4f2ef..6e801a4 100644
--- a/drivers/staging/vt6655/hostap.h
+++ b/drivers/staging/vt6655/hostap.h
@@ -31,8 +31,6 @@
 
 #include "device.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define WLAN_RATE_1M    BIT0
 #define WLAN_RATE_2M    BIT1
 #define WLAN_RATE_5M5   BIT2
@@ -46,12 +44,6 @@
 #define WLAN_RATE_48M   BIT10
 #define WLAN_RATE_54M   BIT11
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 #ifndef ETH_P_PAE
 #define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
 #endif /* ETH_P_PAE */
-- 
1.7.9.5

