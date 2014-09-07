Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaIGAaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 20:30:12 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36730 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIGAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 20:30:11 -0400
From: Raphael Silva <rapphil@gmail.com>
To: akpm@linux-foundation.org
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org,
        Raphael Silva <rapphil@gmail.com>
Subject: [PATCH] Removing textsearch_put reference from the comments.
Date: Sat,  6 Sep 2014 21:29:57 -0300
Message-Id: <1410049797-10317-1-git-send-email-rapphil@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no function named textsearch_put(). Removing it from the comments to avoid misunderstanding.
Textsearch prepare no longer needs textsearch_put.

Signed-off-by: Raphael Silva <rapphil@gmail.com>
---
 lib/textsearch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/textsearch.c b/lib/textsearch.c
index 0c7e9ab..0b79908 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -249,9 +249,7 @@ EXPORT_SYMBOL(textsearch_find_continuous);
  * @flags: search flags
  *
  * Looks up the search algorithm module and creates a new textsearch
- * configuration for the specified pattern. Upon completion all
- * necessary refcnts are held and the configuration must be put back
- * using textsearch_put() after usage.
+ * configuration for the specified pattern.
  *
  * Note: The format of the pattern may not be compatible between
  *       the various search algorithms.
-- 
1.9.1

