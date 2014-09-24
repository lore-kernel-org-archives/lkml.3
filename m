Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaIXPDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:03:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaIXPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:03:10 -0400
Date: Wed, 24 Sep 2014 08:02:22 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-212be3b2320bcf33eff648bc4e1f0edbf4d90acf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20140921184232.GB23727@redhat.com>
References: <20140921184232.GB23727@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/lib/Makefile: Remove the unnecessary "+=
  thunk_64.o"
Git-Commit-ID: 212be3b2320bcf33eff648bc4e1f0edbf4d90acf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  212be3b2320bcf33eff648bc4e1f0edbf4d90acf
Gitweb:     http://git.kernel.org/tip/212be3b2320bcf33eff648bc4e1f0edbf4d90acf
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 20:42:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:15:39 +0200

x86/lib/Makefile: Remove the unnecessary "+= thunk_64.o"

Trivial. We have "lib-y += thunk_$(BITS).o" at the start, no
need to add thunk_64.o if !CONFIG_X86_32.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140921184232.GB23727@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4d4f96a..66127b9 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -39,7 +39,7 @@ endif
 else
         obj-y += iomap_copy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
-        lib-y += thunk_64.o clear_page_64.o copy_page_64.o
+        lib-y += clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
