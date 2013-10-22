Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3JVWbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:11 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:42912 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755710Ab3JVWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3868:3871:4321:5007:6117:6261:7903:8603:10004:10026:10848:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drum14_9deabfe54963
X-Filterd-Recvd-Size: 1604
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH 16/24] ntfs: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:59 -0700
Message-Id: <ee82fe0f8cc8704aba9d3da5258122c70850e436.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ntfs/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 79a8918..a3e6626 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -34,7 +34,7 @@
 #include "debug.h"
 
 /* Definition of the ntfs sysctl. */
-static ctl_table ntfs_sysctls[] = {
+static struct ctl_table ntfs_sysctls[] = {
 	{
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
@@ -46,7 +46,7 @@ static ctl_table ntfs_sysctls[] = {
 };
 
 /* Define the parent directory /proc/sys/fs. */
-static ctl_table sysctls_root[] = {
+static struct ctl_table sysctls_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

