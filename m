Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaLWEiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:38:20 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:41422 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaLWEiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:38:19 -0500
Date: Tue, 23 Dec 2014 07:38:04 +0300
From: samuel kihahu <skihahu@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org,
        oleg.drokin@intel.com
Subject: Re: [PATCH] staging: lustre: cleanup align switch and case
Message-ID: <20141223043804.GA2623@localhost.localdomain>
References: <1419281337-4076-1-git-send-email-skihahu@gmail.com>
 <20141222211801.GA29847@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20141222211801.GA29847@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 22, 2014 at 01:18:01PM -0800, Greg KH wrote:
> On Mon, Dec 22, 2014 at 11:48:57PM +0300, samuel kihahu wrote:
> > From: skihahu <skihahu@gmail.com>
> > 
> > Align switch and case to be at the same indent.
> > 
> > Signed-off-by: samuel kihahu <skihahu@gmail.com>
> 
> The "From:" and "Signed-off-by:" names don't match, which doesn't make
> much sense, right?  Please fix and resend.
> 

I have corrected as requested above.

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-staging-lustre-cleanup-align-switch-and-case.patch"

>From 766dd7eefe8992b90dc69cca085e6719019aae82 Mon Sep 17 00:00:00 2001
From: samuel kihahu <skihahu@gmail.com>
Date: Mon, 22 Dec 2014 18:16:29 +0300
Subject: [PATCH] staging: lustre: cleanup align switch and case

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

--MGYHOYXEY6WxJCY8--
