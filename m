Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaFTTuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:50:24 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49062 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaFTTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:50:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jaroslav Kysela <perex@perex.cz>, Jiri Kosina <trivial@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] trivial: sound/core/seq/seq_memory.c: Fix closing brace followed by if
Date: Fri, 20 Jun 2014 21:50:03 +0200
Message-Id: <1403293803-17650-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a newline, and remove a space while at it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 sound/core/seq/seq_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index 1e206de..4854c21 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -101,7 +101,8 @@ int snd_seq_dump_var_event(const struct snd_seq_event *event,
 			len -= size;
 		}
 		return 0;
-	} if (! (event->data.ext.len & SNDRV_SEQ_EXT_CHAINED)) {
+	}
+	if (!(event->data.ext.len & SNDRV_SEQ_EXT_CHAINED)) {
 		return func(private_data, event->data.ext.ptr, len);
 	}
 
-- 
1.9.2

