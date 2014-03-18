Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaCRJjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:39:42 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:50831 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaCRJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:39:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH trivial 2/2] seq-file: Grammar s/can may/may/g
Date: Tue, 18 Mar 2014 10:39:24 +0100
Message-Id: <1395135565-7118-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395135565-7118-1-git-send-email-geert@linux-m68k.org>
References: <1395135565-7118-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Sometimes it's hard to make a choice between "can" and "may" ;-)

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb108d2..2b798d1caaa3 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -16,7 +16,7 @@
 
 
 /*
- * seq_files have a buffer which can may overflow. When this happens a larger
+ * seq_files have a buffer which may overflow. When this happens a larger
  * buffer is reallocated and all the data will be printed again.
  * The overflow state is true when m->count == m->size.
  */
-- 
1.7.9.5

