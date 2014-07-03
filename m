Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbaGCWIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:09 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:39321 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759667AbaGCWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:967:973:988:989:1260:1345:1359:1437:1534:1539:1566:1711:1714:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3868:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6261:7809:9010:9025:9388:10004:10026:10049:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:14106:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate87_29a4cb7bf5b50
X-Filterd-Recvd-Size: 1427
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] MAINTAINERS: Update cifs location
Date: Thu,  3 Jul 2014 15:07:46 -0700
Message-Id: <4dbbebbdadfc6761da808d50ae1d2706a7f35f67.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 30706a545417 ("cifs: create a new Documentation/ directory
and move docfiles into it") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 54bd82e..a047941 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2366,7 +2366,7 @@ W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
-F:	Documentation/filesystems/cifs.txt
+F:	Documentation/filesystems/cifs/
 F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
-- 
1.8.1.2.459.gbcd45b4.dirty

