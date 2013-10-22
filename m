Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3JVWaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:46 -0400
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:40747 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861Ab3JVWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wave53_5f9757dc9549
X-Filterd-Recvd-Size: 1546
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 07/24] infiniband: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:50 -0700
Message-Id: <9ba950ecbbe17f69ac7362f14bf939180b13091c.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b0f189b..3f93093 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -57,7 +57,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static unsigned int max_backlog = 1024;
 
 static struct ctl_table_header *ucma_ctl_table_hdr;
-static ctl_table ucma_ctl_table[] = {
+static struct ctl_table ucma_ctl_table[] = {
 	{
 		.procname	= "max_backlog",
 		.data		= &max_backlog,
-- 
1.8.1.2.459.gbcd45b4.dirty

