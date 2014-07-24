Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360AbaGXSjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:39:31 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45473 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbaGXSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:39:30 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: remove redundant comments from baseband.h
Date: Thu, 24 Jul 2014 21:39:08 +0300
Message-Id: <1406227148-12181-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments in baseband.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/baseband.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index e31bb76..d90c7f9 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -34,8 +34,6 @@
 #include "tether.h"
 #include "device.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
 //
 // Registers in the BASEBAND
 //
@@ -64,22 +62,12 @@
 #define TOP_RATE_2M         0x00200000
 #define TOP_RATE_1M         0x00100000
 
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Macros ------------------------------*/
-
 #define BBvClearFOE(dwIoBase)				\
 	BBbWriteEmbedded(dwIoBase, 0xB1, 0)
 
 #define BBvSetFOE(dwIoBase)				\
 	BBbWriteEmbedded(dwIoBase, 0xB1, 0x0C)
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 unsigned int
 BBuGetFrameTime(
 	unsigned char byPreambleType,
-- 
1.7.9.5

