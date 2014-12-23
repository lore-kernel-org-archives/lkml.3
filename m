Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaLWH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:58:45 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49095 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaLWH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:58:43 -0500
From: samuel kihahu <skihahu@gmail.com>
X-Google-Original-From: samuel kihahu <samue kihahu skihahu@gmail.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        samuel kihahu <skihahu@gmail.com>
Subject: [PATCH] staging: lustre: cleanup align switch and case
Date: Tue, 23 Dec 2014 10:57:46 +0300
Message-Id: <1419321466-8068-1-git-send-email-skihahu@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: samuel kihahu <skihahu@gmail.com>

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
