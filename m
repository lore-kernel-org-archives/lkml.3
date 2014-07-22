Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaGVMZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:25:53 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58975 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaGVMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:25:50 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: remove redundant comments from 80211hdr.h
Date: Tue, 22 Jul 2014 15:25:18 +0300
Message-Id: <1406031918-19215-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from 80211hdr.h header file

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/80211hdr.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index ba155cd..e05d135 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -33,7 +33,6 @@
 
 #include "ttype.h"
 
-/*---------------------  Export Definitions -------------------------*/
 /* bit type */
 #define BIT0	0x00000001
 #define BIT1	0x00000002
@@ -315,10 +314,4 @@ typedef union tagUWLAN_80211HDR {
 	WLAN_80211HDR_A4        sA4;
 } UWLAN_80211HDR, *PUWLAN_80211HDR;
 
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 #endif /* __80211HDR_H__ */
-- 
1.7.9.5

