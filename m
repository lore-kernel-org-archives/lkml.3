Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3JVWei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:34:38 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:39132 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755629Ab3JVWay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: air96_7918ac2ff41d
X-Filterd-Recvd-Size: 1533
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH 11/24] coda: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:54 -0700
Message-Id: <9180705dd58b8dd70ddb7bca72bcdb53a804294c.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/coda/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index af56ad5..34218a8 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -14,7 +14,7 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fs_table_header;
 
-static ctl_table coda_table[] = {
+static struct ctl_table coda_table[] = {
 	{
 		.procname	= "timeout",
 		.data		= &coda_timeout,
@@ -39,7 +39,7 @@ static ctl_table coda_table[] = {
 	{}
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.procname	= "coda",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

