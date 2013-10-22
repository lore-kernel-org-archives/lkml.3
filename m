Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3JVWa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:59 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:49167 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755662Ab3JVWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: turn88_8219cd17762c
X-Filterd-Recvd-Size: 1573
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Subject: [PATCH 12/24] fscache: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:55 -0700
Message-Id: <16f587e5028f41338a220bcbe6329c342ab2041d.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/fscache/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c27907..5b2c174 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
+struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

