Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbaGYQx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:53:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50488 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaGYQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:53:26 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from power.h
Date: Fri, 25 Jul 2014 19:53:12 +0300
Message-Id: <1406307192-610-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from power.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/power.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/vt6655/power.h b/drivers/staging/vt6655/power.h
index ce56124..936f171 100644
--- a/drivers/staging/vt6655/power.h
+++ b/drivers/staging/vt6655/power.h
@@ -29,19 +29,10 @@
 #ifndef __POWER_H__
 #define __POWER_H__
 
-/*---------------------  Export Definitions -------------------------*/
 #define     C_PWBT                   1000      // micro sec. power up before TBTT
 #define     PS_FAST_INTERVAL         1         // Fast power saving listen interval
 #define     PS_MAX_INTERVAL          4         // MAX power saving listen interval
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 bool
 PSbConsiderPowerDown(
 	void *hDeviceContext,
-- 
1.7.9.5

