Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3LQGMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:12:13 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43120 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3LQGLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:40 -0500
X-AuditID: 9c93017e-b7c17ae000003961-3a-52afeb1809c6
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 5/5] zsmalloc: add maintainers
Date: Tue, 17 Dec 2013 15:12:03 +0900
Message-Id: <1387260723-15817-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387260723-15817-1-git-send-email-minchan@kernel.org>
References: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds maintainer information for zsmalloc into
the MAINTAINERS file.

Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b32aa4b5f04..af237d331765 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9705,6 +9705,14 @@ M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
+ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+M:	Minchan Kim <minchan@kernel.org>
+M:	Nitin Gupta <ngupta@vflare.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zsmalloc.c
+F:	include/linux/zsmalloc.h
+
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
 L:	linux-mm@kvack.org
-- 
1.7.9.5

