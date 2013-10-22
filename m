Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3JVWgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:36:51 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:56397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755430Ab3JVWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: earth14_4be645290623
X-Filterd-Recvd-Size: 1581
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 04/24] tile: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:47 -0700
Message-Id: <62fdce787db6e9765a01e9f9e4e192bd45ed5d24.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/proc.c b/arch/tile/kernel/proc.c
index 681100c..6829a95 100644
--- a/arch/tile/kernel/proc.c
+++ b/arch/tile/kernel/proc.c
@@ -113,7 +113,7 @@ arch_initcall(proc_tile_init);
  * Support /proc/sys/tile directory
  */
 
-static ctl_table unaligned_subtable[] = {
+static struct ctl_table unaligned_subtable[] = {
 	{
 		.procname	= "enabled",
 		.data		= &unaligned_fixup,
@@ -138,7 +138,7 @@ static ctl_table unaligned_subtable[] = {
 	{}
 };
 
-static ctl_table unaligned_table[] = {
+static struct ctl_table unaligned_table[] = {
 	{
 		.procname	= "unaligned_fixup",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

