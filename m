Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbbAOFnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:43:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39581 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbbAOFnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:43:03 -0500
Date: Thu, 15 Jan 2015 11:12:58 +0530
From: Balavasu <kp.balavasu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com, greg@kroah.com
Subject: [PATCH 2/2] staging: lustre: lnet: lnet: trailing statements should
 be on next line
Message-ID: <20150115054257.GA2901@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl issue
Error: trailing statements should be on next line

Signed-off-by: Balavasu <kp.balavasu@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/router.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index cdeb246..0f569a0 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1670,13 +1670,16 @@ lnet_get_tunables (void)
 	char *s;
 
 	s = getenv("LNET_ROUTER_PING_TIMEOUT");
-	if (s != NULL) router_ping_timeout = atoi(s);
+	if (s != NULL)
+		router_ping_timeout = atoi(s);
 
 	s = getenv("LNET_LIVE_ROUTER_CHECK_INTERVAL");
-	if (s != NULL) live_router_check_interval = atoi(s);
+	if (s != NULL)
+		live_router_check_interval = atoi(s);
 
 	s = getenv("LNET_DEAD_ROUTER_CHECK_INTERVAL");
-	if (s != NULL) dead_router_check_interval = atoi(s);
+	if (s != NULL)
+		dead_router_check_interval = atoi(s);
 
 	/* This replaces old lnd_notify mechanism */
 	check_routers_before_use = 1;
-- 
1.9.1

