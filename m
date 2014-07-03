Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbaGCWIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:13 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:38035 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759694AbaGCWIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:4321:5007:6119:6261:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun89_29e9840515856
X-Filterd-Recvd-Size: 1495
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] MAINTAINERS: Use the correct efi-stub location
Date: Thu,  3 Jul 2014 15:07:47 -0700
Message-Id: <f40e93b943b749628d4012812a76e547384ea267.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4171fe2f8a47 ("EFI stub documentation updates") moved
the file, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Roy Franz <roy.franz@linaro.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a047941..e3531a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3362,7 +3362,7 @@ M:	Matt Fleming <matt.fleming@intel.com>
 L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
 S:	Maintained
-F:	Documentation/x86/efi-stub.txt
+F:	Documentation/efi-stub.txt
 F:	arch/ia64/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/x86/include/asm/efi.h
-- 
1.8.1.2.459.gbcd45b4.dirty

