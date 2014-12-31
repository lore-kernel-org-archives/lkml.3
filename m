Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaLaBWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:30 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52372 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaLaBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:26 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] lib/genalloc.c: Remove redundant include
Date: Wed, 31 Dec 2014 02:21:41 +0100
Message-Id: <1419988915-20730-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing this include produces byte-identical output, and thus removes
a false dependency.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/genalloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 2e65d206b01c..17d8f58f6716 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -34,7 +34,6 @@
 #include <linux/rculist.h>
 #include <linux/interrupt.h>
 #include <linux/genalloc.h>
-#include <linux/of_address.h>
 #include <linux/of_device.h>
 
 static inline size_t chunk_size(const struct gen_pool_chunk *chunk)
-- 
2.1.3

