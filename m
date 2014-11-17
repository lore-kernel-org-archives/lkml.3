Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaKQDUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:20:30 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61605 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaKQDU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:20:29 -0500
From: Thomas Wood <tommyandrena@gmail.com>
To: oleg.drokin@intel.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org, Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH] drivers: staging: lustre: lnet: api-nc.c: Fix Style Warnings Remove an unecessary return statement in a void function. Remove an unecessary space between a function name and the parentheses.
Date: Sun, 16 Nov 2014 19:21:35 -0800
Message-Id: <1416194495-18512-1-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---
I hope this hasn't been duplicated...
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

