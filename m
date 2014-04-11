Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaDKVeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:34:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaDKVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:34:04 -0400
Date: Fri, 11 Apr 2014 14:33:46 -0700
From: tip-bot for Miklos Szeredi <tipbot@zytor.com>
Message-ID: <tip-ab0a9358ecf87bb801ce124473e7db713457bec4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mszeredi@suse.cz, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1397211951-20549-2-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-2-git-send-email-miklos@szeredi.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] i386: Wire up the renameat2() syscall
Git-Commit-ID: ab0a9358ecf87bb801ce124473e7db713457bec4
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

Commit-ID:  ab0a9358ecf87bb801ce124473e7db713457bec4
Gitweb:     http://git.kernel.org/tip/ab0a9358ecf87bb801ce124473e7db713457bec4
Author:     Miklos Szeredi <mszeredi@suse.cz>
AuthorDate: Fri, 11 Apr 2014 12:25:37 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Apr 2014 13:59:58 -0700

i386: Wire up the renameat2() syscall

The renameat2() system call was only wired up for x86-64.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Link: http://lkml.kernel.org/r/1397211951-20549-2-git-send-email-miklos@szeredi.hu
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/syscalls/syscall_32.tbl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 96bc506..d6b8679 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -359,3 +359,4 @@
 350	i386	finit_module		sys_finit_module
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
+353	i386	renameat2		sys_renameat2
