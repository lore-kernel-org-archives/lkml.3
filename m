Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaEOPYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:24:32 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42620 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaEOPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:24:31 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH] staging: lustre: socklnd: Remove unnecessary line continuation
Date: Thu, 15 May 2014 16:23:56 +0100
Message-Id: <1400167436-27113-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary line continuation '\' in socklnd.c to meet
kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..a82ac03 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -650,8 +650,7 @@ ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
 				conn = list_entry (ctmp, ksock_conn_t,
 						       ksnc_list);
 				ksocknal_conn_addref(conn);
-				read_unlock(&ksocknal_data. \
-						 ksnd_global_lock);
+				read_unlock(&ksocknal_data.ksnd_global_lock);
 				return (conn);
 			}
 		}
@@ -2299,12 +2298,12 @@ ksocknal_base_shutdown(void)
 				for (j = 0; j < info->ksi_nthreads_max; j++) {
 
 					sched = &info->ksi_scheds[j];
-					LASSERT(list_empty(&sched->\
-							       kss_tx_conns));
-					LASSERT(list_empty(&sched->\
-							       kss_rx_conns));
-					LASSERT(list_empty(&sched-> \
-						  kss_zombie_noop_txs));
+					LASSERT(list_empty(
+						&sched->kss_tx_conns));
+					LASSERT(list_empty(
+						&sched->kss_rx_conns));
+					LASSERT(list_empty(
+						&sched->kss_zombie_noop_txs));
 					LASSERT(sched->kss_nconns == 0);
 				}
 			}
@@ -2683,8 +2682,8 @@ ksocknal_search_new_ipif(ksock_net_t *net)
 		list_for_each_entry(tmp, &ksocknal_data.ksnd_nets,
 					ksnn_list) {
 			for (j = 0; !found && j < tmp->ksnn_ninterfaces; j++) {
-				char *ifnam2 = &tmp->ksnn_interfaces[j].\
-					     ksni_name[0];
+				char *ifnam2 =
+					&tmp->ksnn_interfaces[j].ksni_name[0];
 				char *colon2 = strchr(ifnam2, ':');
 
 				if (colon2 != NULL)
-- 
1.7.9.5

