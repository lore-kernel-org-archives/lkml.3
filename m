Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaG1N3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:29:50 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:52663 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaG1N31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:27 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 7/7] printk: correct some more typos
Date: Mon, 28 Jul 2014 08:29:20 -0500
Message-Id: <1406554160-9562-8-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects a few more typographical errors in "printk.c".

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 982873b..83cf258 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -201,7 +201,7 @@ static int console_may_schedule;
  *
  * The optional key/value pairs are attached as continuation lines starting
  * with a space character and terminated by a newline. All possible
- * non-prinatable characters are escaped in the "\xff" notation.
+ * non-printable characters are escaped in the "\xff" notation.
  *
  * Users of the export format should ignore possible additional values
  * separated by ',', and find the message after the ';' character.
@@ -614,7 +614,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	/*
 	 * If we couldn't merge continuation line fragments during the print,
 	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
+	 * records. Merging the records isn't always necessarily correct, like
 	 * when we hit a race during printing. In most cases though, it produces
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
@@ -2905,7 +2905,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		prev = msg->flags;
 	}
 
-	/* last message in next interation */
+	/* last message in next iteration */
 	next_seq = seq;
 	next_idx = idx;
 
@@ -2931,7 +2931,7 @@ out:
 EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
 
 /**
- * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
+ * kmsg_dump_rewind_nolock - reset the iterator (unlocked version)
  * @dumper: registered kmsg dumper
  *
  * Reset the dumper's iterator so that kmsg_dump_get_line() and
@@ -2949,7 +2949,7 @@ void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 }
 
 /**
- * kmsg_dump_rewind - reset the interator
+ * kmsg_dump_rewind - reset the iterator
  * @dumper: registered kmsg dumper
  *
  * Reset the dumper's iterator so that kmsg_dump_get_line() and
-- 
1.9.1

