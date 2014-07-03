Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbaGCWno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:44 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:46014 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaGCWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:42 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 13/18] lib: bitmap: Fix typo in kerneldoc for bitmap_pos_to_ord
Date: Fri,  4 Jul 2014 00:42:59 +0200
Message-Id: <1404427384-11422-14-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few lines above, it was stated that positions for non-set bits are
mapped to -1, which is obviously also what the code does.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index d4b3a6d..2714df9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -712,7 +712,7 @@ EXPORT_SYMBOL(bitmap_parselist_user);
  *
  * If for example, just bits 4 through 7 are set in @buf, then @pos
  * values 4 through 7 will get mapped to 0 through 3, respectively,
- * and other @pos values will get mapped to 0.  When @pos value 7
+ * and other @pos values will get mapped to -1.  When @pos value 7
  * gets mapped to (returns) @ord value 3 in this example, that means
  * that bit 7 is the 3rd (starting with 0th) set bit in @buf.
  *
-- 
1.9.2

