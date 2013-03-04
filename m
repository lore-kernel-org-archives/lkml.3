Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3CDWc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:32:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:44013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab3CDWcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:32:24 -0500
Message-ID: <5135211B.2070408@infradead.org>
Date: Mon, 04 Mar 2013 14:32:59 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] signals: fix new kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in kernel/signal.c:

Warning(kernel/signal.c:2689): No description found for parameter 'uset'
Warning(kernel/signal.c:2689): Excess function parameter 'set' description in 'sys_rt_sigpending'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Alexander Viro <viro@zeniv.linux.org.uk>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-39-rc1.orig/kernel/signal.c
+++ lnx-39-rc1/kernel/signal.c
@@ -2682,7 +2682,7 @@ static int do_sigpending(void *set, unsi
 /**
  *  sys_rt_sigpending - examine a pending signal that has been raised
  *			while blocked
- *  @set: stores pending signals
+ *  @uset: stores pending signals
  *  @sigsetsize: size of sigset_t type or larger
  */
 SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
