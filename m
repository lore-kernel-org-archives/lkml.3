Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3CEH5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:57:47 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45985 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3CEH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:57:45 -0500
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Al Viro <viro@zenic.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH 2/2] :kernel:signal: Fixed coding style issue.
Date: Tue,  5 Mar 2013 01:13:54 +0200
Message-Id: <1362438834-28949-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue by removing trailing whitespaces.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 kernel/signal.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2ec870a..fd9a953 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2369,7 +2369,7 @@ relock:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered -
  * @sig:		number of signal being delivered
  * @info:		siginfo_t of signal being delivered
  * @ka:			sigaction setting that chose the handler
@@ -3128,7 +3128,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	return 0;
 }
 
-static int 
+static int
 do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
 {
 	stack_t oss;
@@ -3272,7 +3272,7 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
-	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t)); 
+	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
 
 #endif
@@ -3397,7 +3397,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 	if (!ret && oact) {
 		sigset_to_compat(&mask, &old_ka.sa.sa_mask);
-		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler),
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
 		ret |= __put_user(old_ka.sa.sa_flags, &oact->sa_flags);
@@ -3573,7 +3573,7 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 		return -EFAULT;
 	return sigsuspend(&newset);
 }
- 
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
 {
-- 
1.7.9.5

