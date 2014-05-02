Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaEBSyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:54:45 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49940 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEBSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:54:44 -0400
From: "Seth Jennings" <sjennings@variantweb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH] MAINTAINERS: zswap/zbud: change maintainer email address
Date: Fri,  2 May 2014 13:54:41 -0500
Message-Id: <1399056881-18153-1-git-send-email-sjennings@variantweb.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjenning@linux.vnet.ibm.com is no longer a viable entity.

Resend from 2013-10-16.  Just noticed that it didn't get upstream.

Signed-off-by: Seth Jennings <sjennings@variantweb.net>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 900d98e..b538cdf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9808,7 +9808,7 @@ F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
 ZBUD COMPRESSED PAGE ALLOCATOR
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zbud.c
@@ -9853,7 +9853,7 @@ F:	mm/zsmalloc.c
 F:	include/linux/zsmalloc.h
 
 ZSWAP COMPRESSED SWAP CACHING
-M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+M:	Seth Jennings <sjennings@variantweb.net>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
-- 
1.9.0

