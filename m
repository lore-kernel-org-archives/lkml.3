Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIBMnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:43:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63470 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaIBMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:43:01 -0400
X-AuditID: cbfee690-f79ce6d00000115a-74-5405bb537a1f
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
To: akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        paulmck@linux.vnet.ibm.com, jkosina@suse.cz, fabf@skynet.be,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
Cc: pintu.k@samsung.com, vishu13285@gmail.com,
        "vishnu.ps" <vishnu.ps@samsung.com>
Subject: [PATCH] kernel/signal.c: whitespace fixes
Date: Tue, 02 Sep 2014 18:10:57 +0530
Message-id: <1409661657-7598-1-git-send-email-vishnu.ps@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkVjd4N2uIwZd1shZz1q9hs3h5SNOi
	6/dPNovdcxazWFzeNYfNYuv+VkaLt5u/s1r0fT/MbjF55xtGi/N/j7NaTOm7y2ixZcVDVgce
	j52z7rJ7nJjxm8XjwaHNLB435xV6vN93lc2jb8sqRo+73f+YPc4sOMLu8XmTnMemJ2+ZArii
	uGxSUnMyy1KL9O0SuDI2T9rHUrDGrOLHUY4GxkPaXYycHBICJhJfFi9ngrDFJC7cW8/WxcjF
	ISSwlFHicesKNpiinV/+QyUWMUo8/9EJ5fxhlFh9o5UZpIpNwFBiw+wj7CAJEYETjBJ/179k
	AUkwC4RIPFi4hhXEFhYwkli4rQPMZhFQlZh36yzQJA4OXgEXib/b5SG2KUgs+7KWGWSOhMAx
	dolLa2axQdQLSHybfIgFpF5CQFZi0wFmiHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchErzgx
	t7g0L10vOT93EyMwLk7/ezZhB+O9A9aHGAU4GJV4eCV+sIQIsSaWFVfmHmI0BdowkVlKNDkf
	GH15JfGGxmZGFqYmpsZG5pZmSuK8r6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgLM3+
	LpW8/8nkbbLhb0O73ay5s5wjpnbdVDi9Jm3xe32py7n2G/QLnSelrpR7sl8316UjsZbzylxt
	19wv/ivUcoXXeh04eyhu4SvzV2m7d6w5zr5m24QNaya9b9i0MyPi8GNNWZur5nf6s//FhdZ+
	VvnoW9D+1mqS7sSFUzZsF5nKde6fqPKZV0osxRmJhlrMRcWJAPmsetKGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd3g3awhBtPuC1jMWb+GzeLlIU2L
	rt8/2Sx2z1nMYnF51xw2i637Wxkt3m7+zmrR9/0wu8XknW8YLc7/Pc5qMaXvLqPFlhUPWR14
	PHbOusvucWLGbxaPB4c2s3jcnFfo8X7fVTaPvi2rGD3udv9j9jiz4Ai7x+dNch6bnrxlCuCK
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsXnSPpaCNWYVP45yNDAe0u5i
	5OSQEDCR2PnlPxuELSZx4d56IJuLQ0hgEaPE8x+dUM4fRonVN1qZQarYBAwlNsw+wg6SEBE4
	wSjxd/1LFpAEs0CIxIOFa1hBbGEBI4mF2zrAbBYBVYl5t84CTeLg4BVwkfi7XR5im4LEsi9r
	mScwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERx1z6R3MK5qsDjEKMDBqMTDK/GD
	JUSINbGsuDL3EKMEB7OSCO+inawhQrwpiZVVqUX58UWlOanFhxhNgZZPZJYSTc4HJoS8knhD
	YxNzU2NTSxMLEzNLJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MDovsOOqz9mhUmAuaHL81
	+91BGaMb24KuX6s7JC53lL0sWvH8h2VHTgeeKt754ATbnmMbW+bskS2zuJ3FUqUe1CMR0C6Y
	Pn3Co0r/SUInn+9Xfa/zZlV1s69E/Xldn6OxUpLL6v6dSn757nlSyamyT7wBjakcIrcUNL4d
	zPh8unj3zy9Jx9bJKbEUZyQaajEXFScCAKRWeWTQAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "vishnu.ps" <vishnu.ps@samsung.com>

Fix minor errors and warning messages in kernel/signal.c.  These errors were
reported by checkpatch while working with some modifications in signal.c
file.

ERROR: code indent should use tabs where possible - 18
ERROR: need consistent spacing around '&' (ctx:WxO) - 11
ERROR: space prohibited after that '~' (ctx:OxW) - 11
ERROR: trailing whitespace - 4
ERROR: space required after that ',' (ctx:VxV) - 4
ERROR: trailing statements should be on next line - 3
ERROR: "foo * bar" should be "foo *bar" - 1

total 52 errors fixed.

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 kernel/signal.c | 75 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f..06e3d72 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -109,25 +109,28 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
+			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 4:
+		ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2:
+		ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1:
+		ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
 
-#define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
+#define PENDING(p, b) has_pending_signals(&(p)->signal, (b))
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
@@ -180,7 +183,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	 * Handle the first word specially: it contains the
 	 * synchronous signals that need to be dequeued first.
 	 */
-	x = *s &~ *m;
+	x = *s & ~*m;
 	if (x) {
 		if (x & SYNCHRONOUS_MASK)
 			x &= SYNCHRONOUS_MASK;
@@ -191,7 +194,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = 1; i < _NSIG_WORDS; ++i) {
-			x = *++s &~ *++m;
+			x = *++s & ~*++m;
 			if (!x)
 				continue;
 			sig = ffz(~x) + i*_NSIG_BPW + 1;
@@ -200,7 +203,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 		break;
 
 	case 2:
-		x = s[1] &~ m[1];
+		x = s[1] & ~m[1];
 		if (!x)
 			break;
 		sig = ffz(~x) + _NSIG_BPW + 1;
@@ -1431,7 +1434,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 				pid ? find_vpid(-pid) : task_pgrp(current));
 	} else {
 		int retval = 0, count = 0;
-		struct task_struct * p;
+		struct task_struct *p;
 
 		for_each_process(p) {
 			if (task_pid_vnr(p) > 1 &&
@@ -1622,8 +1625,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1745,20 +1748,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_utime = cputime_to_clock_t(utime);
 	info.si_stime = cputime_to_clock_t(stime);
 
- 	info.si_code = why;
- 	switch (why) {
- 	case CLD_CONTINUED:
- 		info.si_status = SIGCONT;
- 		break;
- 	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
- 		break;
- 	case CLD_TRAPPED:
- 		info.si_status = tsk->exit_code & 0x7f;
- 		break;
- 	default:
- 		BUG();
- 	}
+	info.si_code = why;
+	switch (why) {
+	case CLD_CONTINUED:
+		info.si_status = SIGCONT;
+		break;
+	case CLD_STOPPED:
+		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		break;
+	case CLD_TRAPPED:
+		info.si_status = tsk->exit_code & 0x7f;
+		break;
+	default:
+		BUG();
+	}
 
 	sighand = parent->sighand;
 	spin_lock_irqsave(&sighand->siglock, flags);
@@ -2357,7 +2360,7 @@ relock:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered -
  * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
@@ -3195,7 +3198,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 out:
 	return error;
 }
-SYSCALL_DEFINE2(sigaltstack,const stack_t __user *,uss, stack_t __user *,uoss)
+SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss, stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
 }
@@ -3274,7 +3277,7 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
-	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t)); 
+	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
 
 #endif
@@ -3399,7 +3402,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 	if (!ret && oact) {
 		sigset_to_compat(&mask, &old_ka.sa.sa_mask);
-		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler),
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
 		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
@@ -3416,7 +3419,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 #ifdef CONFIG_OLD_SIGACTION
 SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct old_sigaction __user *, act,
-	        struct old_sigaction __user *, oact)
+		struct old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3452,7 +3455,7 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
 COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct compat_old_sigaction __user *, act,
-	        struct compat_old_sigaction __user *, oact)
+		struct compat_old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3575,7 +3578,7 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 		return -EFAULT;
 	return sigsuspend(&newset);
 }
- 
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
 {
-- 
1.8.3.2

