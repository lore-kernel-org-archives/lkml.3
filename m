Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3JVWhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:37:50 -0400
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:56397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754177Ab3JVWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fire93_34977000c151
X-Filterd-Recvd-Size: 1793
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/24] arm: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:44 -0700
Message-Id: <cc34e4e3e4f1475585e5971ffeaf7bad39791456.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/kernel/isa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 3464859..9d1cf71 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -20,7 +20,7 @@
 
 static unsigned int isa_membase, isa_portbase, isa_portshift;
 
-static ctl_table ctl_isa_vars[4] = {
+static struct ctl_table ctl_isa_vars[4] = {
 	{
 		.procname	= "membase",
 		.data		= &isa_membase, 
@@ -44,7 +44,7 @@ static ctl_table ctl_isa_vars[4] = {
 
 static struct ctl_table_header *isa_sysctl_header;
 
-static ctl_table ctl_isa[2] = {
+static struct ctl_table ctl_isa[2] = {
 	{
 		.procname	= "isa",
 		.mode		= 0555,
@@ -52,7 +52,7 @@ static ctl_table ctl_isa[2] = {
 	}, {}
 };
 
-static ctl_table ctl_bus[2] = {
+static struct ctl_table ctl_bus[2] = {
 	{
 		.procname	= "bus",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

