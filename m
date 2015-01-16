Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbbAPBpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:45:05 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52637 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbbAPBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:44:59 -0500
From: Jia He <hejianet@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jia He <hejianet@gmail.com>, Jeremiah Mahler <jmmahler@gmail.com>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] staging: lustre: libcfs: fix space between function and open parenthesis
Date: Fri, 16 Jan 2015 09:45:47 +0800
Message-Id: <1421372747-2954-2-git-send-email-hejianet@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421372747-2954-1-git-send-email-hejianet@gmail.com>
References: <20150114063518.GA18644@hudson.localdomain>
 <1421372747-2954-1-git-send-email-hejianet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the space warning checked by check_patch.pl

Signed-off-by: Jia He <hejianet@gmail.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/lustre/lustre/libcfs/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index b9ee37c..1af6a37 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -42,7 +42,7 @@
 #include "../../include/linux/lnet/lnet.h"
 #include "tracefile.h"
 
-static void kportal_memhog_free (struct libcfs_device_userstate *ldu)
+static void kportal_memhog_free(struct libcfs_device_userstate *ldu)
 {
 	struct page **level0p = &ldu->ldu_memhog_root_page;
 	struct page **level1p;
-- 
1.9.1

