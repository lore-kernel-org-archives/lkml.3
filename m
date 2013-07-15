Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3GOAnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:43:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3GOAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:43:06 -0400
Message-ID: <51E34567.4090307@infradead.org>
Date: Sun, 14 Jul 2013 17:42:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] wait.c: fix new wake_up_atomic_t kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in kernel/wait.c:

Warning(kernel/wait.c:374): No description found for parameter 'p'
Warning(kernel/wait.c:374): Excess function parameter 'word' description in 'wake_up_atomic_t'
Warning(kernel/wait.c:374): Excess function parameter 'bit' description in 'wake_up_atomic_t'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Howells <dhowells@redhat.com>
---
 kernel/wait.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lnx-311-rc1.orig/kernel/wait.c
+++ lnx-311-rc1/kernel/wait.c
@@ -362,8 +362,7 @@ EXPORT_SYMBOL(out_of_line_wait_on_atomic
 
 /**
  * wake_up_atomic_t - Wake up a waiter on a atomic_t
- * @word: The word being waited on, a kernel virtual address
- * @bit: The bit of the word being waited on
+ * @p: The atomic_t being waited on, a kernel virtual address
  *
  * Wake up anyone waiting for the atomic_t to go to zero.
  *
