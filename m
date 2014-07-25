Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbaGYQ0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:26:32 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:46855 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760590AbaGYQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:26:31 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from IEEE11h.h
Date: Fri, 25 Jul 2014 19:26:14 +0300
Message-Id: <1406305574-32102-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from IEEE11h.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/IEEE11h.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/vt6655/IEEE11h.h b/drivers/staging/vt6655/IEEE11h.h
index 8819fa1..5519220 100644
--- a/drivers/staging/vt6655/IEEE11h.h
+++ b/drivers/staging/vt6655/IEEE11h.h
@@ -35,16 +35,6 @@
 #include "80211hdr.h"
 #include "80211mgr.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 bool IEEE11hbMSRRepTx(
 	void *pMgmtHandle
 );
-- 
1.7.9.5

