Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaGQOJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:09:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47278 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbaGQOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:09:18 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] printk: correct some more typos
Date: Thu, 17 Jul 2014 09:09:11 -0500
Message-Id: <1405606151-19875-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405606151-19875-1-git-send-email-elder@linaro.org>
References: <1405606151-19875-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects a few more typographical errors in "printk.c".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3174ba9..eff68a4 100644
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
@@ -615,7 +615,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	/*
 	 * If we couldn't merge continuation line fragments during the print,
 	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
+	 * records. Merging the records isn't always necessarily correct, like
 	 * when we hit a race during printing. In most cases though, it produces
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
@@ -2890,7 +2890,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		prev = msg->flags;
 	}
 
-	/* last message in next interation */
+	/* last message in next iteration */
 	next_seq = seq;
 	next_idx = idx;
 
@@ -2916,7 +2916,7 @@ out:
 EXPORT_SYMBOL_GPL(kmsg_dump_get_buffer);
 
 /**
- * kmsg_dump_rewind_nolock - reset the interator (unlocked version)
+ * kmsg_dump_rewind_nolock - reset the iterator (unlocked version)
  * @dumper: registered kmsg dumper
  *
  * Reset the dumper's iterator so that kmsg_dump_get_line() and
@@ -2934,7 +2934,7 @@ void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 }
 
 /**
- * kmsg_dump_rewind - reset the interator
+ * kmsg_dump_rewind - reset the iterator
  * @dumper: registered kmsg dumper
  *
  * Reset the dumper's iterator so that kmsg_dump_get_line() and
-- 
1.9.1

