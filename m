Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3FNT2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:28:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37315 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3FNT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:28:30 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add zswap and zbud maintainer
Date: Fri, 14 Jun 2013 14:28:20 -0500
Message-Id: <1371238100-4621-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061419-3620-0000-0000-0000031EF442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds maintainer information for zswap and zbud
into the MAINTAINERS file.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..8c5897e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9011,6 +9011,13 @@ F:	Documentation/networking/z8530drv.txt
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
+ZBUD COMPRESSED PAGE ALLOCATOR
+M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zbud.c
+F:	include/linux/zbud.h
+
 ZD1211RW WIRELESS DRIVER
 M:	Daniel Drake <dsd@gentoo.org>
 M:	Ulrich Kunitz <kune@deine-taler.de>
@@ -9033,6 +9040,12 @@ M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
+ZSWAP COMPRESSED SWAP CACHING
+M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zswap.c
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
1.7.9.5

