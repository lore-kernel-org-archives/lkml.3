Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112AbaGCWIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:41 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:59165 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965029AbaGCWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:967:968:973:988:989:1260:1345:1359:1437:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4659:5007:6261:7901:7903:9025:10004:10026:10030:10049:10848:11232:11257:11657:11658:11914:12517:12519:12555:13311:13357:13437:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mass65_2daca8689f144
X-Filterd-Recvd-Size: 1330
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] MAINTAINERS: Remove unused NFSD pattern
Date: Thu,  3 Jul 2014 15:07:59 -0700
Message-Id: <cd01b0caa460190010b7e06f74e090a34c05fdae.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A series of commits by Christoph Hellwig removed all the files
in this directory, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b7e3a32..de0d181 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5082,7 +5082,6 @@ L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
 F:	fs/nfsd/
-F:	include/linux/nfsd/
 F:	include/uapi/linux/nfsd/
 F:	fs/lockd/
 F:	fs/nfs_common/
-- 
1.8.1.2.459.gbcd45b4.dirty

