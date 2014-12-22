Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaLVUuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:50:20 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:62172 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaLVUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:50:19 -0500
From: samuel kihahu <skihahu@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        skihahu <skihahu@gmail.com>
Subject: [PATCH] staging: lustre: cleanup align switch and case
Date: Mon, 22 Dec 2014 23:48:57 +0300
Message-Id: <1419281337-4076-1-git-send-email-skihahu@gmail.com>
X-Mailer: git-send-email 1.8.3.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: skihahu <skihahu@gmail.com>

Align switch and case to be at the same indent.

Signed-off-by: samuel kihahu <skihahu@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/module.c | 50 +++++++++++++--------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
index 6dd4309..b5f07fa 100644
--- a/drivers/staging/lustre/lnet/selftest/module.c
+++ b/drivers/staging/lustre/lnet/selftest/module.c
@@ -61,31 +61,31 @@ lnet_selftest_fini(void)
	int	i;

	switch (lst_init_step) {
-		case LST_INIT_CONSOLE:
-			lstcon_console_fini();
-		case LST_INIT_FW:
-			sfw_shutdown();
-		case LST_INIT_RPC:
-			srpc_shutdown();
-		case LST_INIT_WI_TEST:
-			for (i = 0;
-			     i < cfs_cpt_number(lnet_cpt_table()); i++) {
-				if (lst_sched_test[i] == NULL)
-					continue;
-				cfs_wi_sched_destroy(lst_sched_test[i]);
-			}
-			LIBCFS_FREE(lst_sched_test,
-				    sizeof(lst_sched_test[0]) *
-				    cfs_cpt_number(lnet_cpt_table()));
-			lst_sched_test = NULL;
-
-		case LST_INIT_WI_SERIAL:
-			cfs_wi_sched_destroy(lst_sched_serial);
-			lst_sched_serial = NULL;
-		case LST_INIT_NONE:
-			break;
-		default:
-			LBUG();
+	case LST_INIT_CONSOLE:
+		lstcon_console_fini();
+	case LST_INIT_FW:
+		sfw_shutdown();
+	case LST_INIT_RPC:
+		srpc_shutdown();
+	case LST_INIT_WI_TEST:
+		for (i = 0;
+		     i < cfs_cpt_number(lnet_cpt_table()); i++) {
+			if (lst_sched_test[i] == NULL)
+				continue;
+			cfs_wi_sched_destroy(lst_sched_test[i]);
+		}
+		LIBCFS_FREE(lst_sched_test,
+			    sizeof(lst_sched_test[0]) *
+			    cfs_cpt_number(lnet_cpt_table()));
+		lst_sched_test = NULL;
+
+	case LST_INIT_WI_SERIAL:
+		cfs_wi_sched_destroy(lst_sched_serial);
+		lst_sched_serial = NULL;
+	case LST_INIT_NONE:
+		break;
+	default:
+		LBUG();
	}
	return;
 }
