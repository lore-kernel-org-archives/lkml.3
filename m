Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3KSN0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:26:43 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62446 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3KSN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:40 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 7/9] staging/lustre/lnet: constify name argument of lstcon_group_find/lstcon_batch_find
Date: Tue, 19 Nov 2013 21:23:46 +0800
Message-Id: <1384867428-8395-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

This is part of original Lustre commit in external tree.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3093
Lustre-change: http://review.whamcloud.com/6092
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 73d60e9..a27dfa6 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -265,7 +265,7 @@ lstcon_group_decref(lstcon_group_t *grp)
 }
 
 static int
-lstcon_group_find(char *name, lstcon_group_t **grpp)
+lstcon_group_find(const char *name, lstcon_group_t **grpp)
 {
 	lstcon_group_t   *grp;
 
@@ -831,7 +831,7 @@ lstcon_group_info(char *name, lstcon_ndlist_ent_t *gents_p,
 }
 
 int
-lstcon_batch_find(char *name, lstcon_batch_t **batpp)
+lstcon_batch_find(const char *name, lstcon_batch_t **batpp)
 {
 	lstcon_batch_t   *bat;
 
-- 
1.7.9.5

