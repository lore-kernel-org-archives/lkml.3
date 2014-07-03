Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbaGCWMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:12:49 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:41690 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754150AbaGCWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3351:3865:3867:5007:6261:6298:7809:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:13846:14093:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: robin88_2960eb195dd4a
X-Filterd-Recvd-Size: 1775
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] MAINTAINERS: Update microcode patterns
Date: Thu,  3 Jul 2014 15:07:45 -0700
Message-Id: <1100bcda7fae2a18a8271849e0ef4be1d1c4aeb5.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bad5fa631fca ("x86, microcode: Move to a proper location")
moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b9f079b..54bd82e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -604,7 +604,7 @@ AMD MICROCODE UPDATE SUPPORT
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	amd64-microcode@amd64.org
 S:	Maintained
-F:	arch/x86/kernel/microcode_amd.c
+F:	arch/x86/kernel/cpu/microcode/amd*
 
 AMD XGBE DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
@@ -4630,8 +4630,8 @@ F:	drivers/platform/x86/intel_menlow.c
 INTEL IA32 MICROCODE UPDATE SUPPORT
 M:	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
 S:	Maintained
-F:	arch/x86/kernel/microcode_core.c
-F:	arch/x86/kernel/microcode_intel.c
+F:	arch/x86/kernel/cpu/microcode/core*
+F:	arch/x86/kernel/cpu/microcode/intel*
 
 INTEL I/OAT DMA DRIVER
 M:	Dan Williams <dan.j.williams@intel.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

