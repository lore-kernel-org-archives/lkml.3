Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaKIJLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:11:51 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60325 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbaKIJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:11:48 -0500
X-IronPort-AV: E=Sophos;i="5.07,345,1413237600"; 
   d="scan'208";a="105805278"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: kernel-janitors@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: lustre: libcfs: remove final uses of the GOTO macro
Date: Sun,  9 Nov 2014 10:06:34 +0100
Message-Id: <1415523994-12520-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove the goto logging function, as it is no longer used.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/libcfs/debug.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 2c15a9e..859129d 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -460,11 +460,3 @@ void libcfs_debug_set_level(unsigned int debug_level)
 }
 
 EXPORT_SYMBOL(libcfs_debug_set_level);
-
-void libcfs_log_goto(struct libcfs_debug_msg_data *msgdata, const char *label,
-		     long_ptr_t rc)
-{
-	libcfs_debug_msg(msgdata, "Process leaving via %s (rc=%lu : %ld : %#lx)\n",
-			 label, (ulong_ptr_t)rc, rc, rc);
-}
-EXPORT_SYMBOL(libcfs_log_goto);

