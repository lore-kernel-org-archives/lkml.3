Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaAUN7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:59:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbaAUN6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:58:17 -0500
From: Florian Weimer <fweimer@redhat.com>
Date: Mon, 20 Jan 2014 17:10:08 +0100
Subject: [PATCH 3/3] x86: wire fsetxattrat, fgetxattrat, flistxattrat,
 fremovexattrat syscalls
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Message-Id: <20140121135811.1F1F8401159CA@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Florian Weimer <fweimer@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl | 4 ++++
 arch/x86/syscalls/syscall_64.tbl | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index aabfb83..e9232bb 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,7 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	fsetxattrat		sys_fsetxattrat
+352	i386	fgetxattrat		sys_fgetxattrat
+353	i386	flistxattrat		sys_flistxattrat
+354	i386	fremovexattrat		sys_fremovexattrat
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65d..3fab833 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,10 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	fsetxattrat		sys_fsetxattrat
+315	common	fgetxattrat		sys_fgetxattrat
+316	common	flistxattrat		sys_flistxattrat
+317	common	fremovexattrat		sys_fremovexattrat
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.8.3.1

