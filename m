Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaKQTM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:12:26 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44215 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaKQTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:12:23 -0500
From: Thomas Wood <tommyandrena@gmail.com>
To: oleg.drokin@intel.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH] drivers: staging: lustre: lnet: api-nc.c: Fix Style Warnings
Date: Mon, 17 Nov 2014 11:11:36 -0800
Message-Id: <1416251497-4222-1-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141117075155.GD4905@mwanda>
References: <20141117075155.GD4905@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Subject line containing the entire patch description.
>8----------------------------------------------------------------------------8<

Remove an unecessary return statement in a void function.
Remove an unecessary space between a function name and the parentheses.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/api-ni.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 5e6e4e2..faceb95 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -277,7 +277,7 @@ lnet_find_lnd_by_type(int type)
 	struct list_head	 *tmp;
 
 	/* holding lnd mutex */
-	list_for_each (tmp, &the_lnet.ln_lnds) {
+	list_for_each(tmp, &the_lnet.ln_lnds) {
 		lnd = list_entry(tmp, lnd_t, lnd_list);
 
 		if ((int)lnd->lnd_type == type)
@@ -1645,7 +1645,6 @@ lnet_destroy_ping_info(void)
 		    offsetof(lnet_ping_info_t,
 			     pi_ni[the_lnet.ln_ping_info->pi_nnis]));
 	the_lnet.ln_ping_info = NULL;
-	return;
 }
 
 int
-- 
1.7.10.4

