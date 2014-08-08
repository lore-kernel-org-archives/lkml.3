Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaHHPTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:19:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55865 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbaHHPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:19:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Graf <tgraf@suug.ch>
Subject: [PATCH trivial 3/4] lib: rhashtable: Spelling s/compuate/compute/
Date: Fri,  8 Aug 2014 17:19:14 +0200
Message-Id: <1407511155-5264-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
References: <1407511155-5264-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Graf <tgraf@suug.ch>
---
 lib/rhashtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index e6940cf16628..06f24ff08ac8 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -61,7 +61,7 @@ static u32 __hashfn(const struct rhashtable *ht, const void *key,
 
 /**
  * rhashtable_hashfn - compute hash for key of given length
- * @ht:		hash table to compuate for
+ * @ht:		hash table to compute for
  * @key:	pointer to key
  * @len:	length of key
  *
@@ -92,7 +92,7 @@ static u32 obj_hashfn(const struct rhashtable *ht, const void *ptr, u32 hsize)
 
 /**
  * rhashtable_obj_hashfn - compute hash for hashed object
- * @ht:		hash table to compuate for
+ * @ht:		hash table to compute for
  * @ptr:	pointer to hashed object
  *
  * Computes the hash value using the hash function `hashfn` respectively
-- 
1.9.1

