Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3GHQkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:40:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42103 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3GHQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:40:21 -0400
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aldo Iljazi <neonsync1@gmail.com>
Subject: [PATCH] Staging: cxt1e1: ossiRelease.c: fixed a coding style issue.
Date: Mon,  8 Jul 2013 19:40:17 +0300
Message-Id: <1373301617-19688-1-git-send-email-neonsync1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue, specifically checkpatch.pl complain:
ossiRelease.c:27: WARNING: line over 80 characters

Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
---
 drivers/staging/cxt1e1/ossiRelease.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/cxt1e1/ossiRelease.c b/drivers/staging/cxt1e1/ossiRelease.c
index f17a902..35575bf 100644
--- a/drivers/staging/cxt1e1/ossiRelease.c
+++ b/drivers/staging/cxt1e1/ossiRelease.c
@@ -24,6 +24,7 @@
  *-----------------------------------------------------------------------------
  */
 
-char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  Copyright (c) 2008 One Stop Systems$";
+char pmcc4_OSSI_release[] = "$Release: PMCC4_3_1B,  "
+"Copyright (c) 2008 One Stop Systems$";
 
 /***  End-of-File  ***/
-- 
1.7.9.5

