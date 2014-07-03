Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbaGCWJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:09:24 -0400
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:38054 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759885AbaGCWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:968:973:982:988:989:1260:1345:1359:1534:1539:1566:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:4321:4385:5007:6119:6120:6261:7809:7901:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade47_2d1775c58ca38
X-Filterd-Recvd-Size: 1373
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] MAINTAINERS: Remove unused radeon drm pattern
Date: Thu,  3 Jul 2014 15:07:57 -0700
Message-Id: <4041d805f4ce1b079023526b889ca6fea517a3b8.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8dcedd7e87f4 ("UAPI: (Scripted) Disintegrate include/drm")
moved the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: David Howells <dhowells@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f223d8f..09b4a67 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2989,7 +2989,6 @@ L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~agd5f/linux
 S:	Supported
 F:	drivers/gpu/drm/radeon/
-F:	include/drm/radeon*
 F:	include/uapi/drm/radeon*
 
 DRM PANEL DRIVERS
-- 
1.8.1.2.459.gbcd45b4.dirty

