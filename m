Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbaHKS2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:28:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45447 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaHKS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:28:29 -0400
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Srikrishan Malik <srikrishanmalik@gmail.com>
Subject: [PATCH v2 02/13] staging: lustre: remove spaces from start of line
Date: Mon, 11 Aug 2014 23:57:28 +0530
Message-Id: <1407781659-728-2-git-send-email-srikrishanmalik@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:

WARNING: please, no spaces at the start of a line

Signed-off-by: Srikrishan Malik <srikrishanmalik@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index d1d891b91663..f883d9c28f20 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -209,6 +209,6 @@ static struct lprocfs_vars lprocfs_mdc_module_vars[] = {
 
 void lprocfs_mdc_init_vars(struct lprocfs_static_vars *lvars)
 {
-    lvars->module_vars  = lprocfs_mdc_module_vars;
-    lvars->obd_vars     = lprocfs_mdc_obd_vars;
+	lvars->module_vars  = lprocfs_mdc_module_vars;
+	lvars->obd_vars     = lprocfs_mdc_obd_vars;
 }
-- 
1.9.3

