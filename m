Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164Ab3JPWCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:02:39 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50200 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760759Ab3JPWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:02:37 -0400
From: Jim Lieb <jlieb@panasas.com>
To: tytso@mit.edu, viro@zeniv.linux.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com, Jim Lieb <jlieb@panasas.com>
Subject: [PATCH 3/3] switch_creds: Assign x86_64 syscall number for switch_creds
Date: Wed, 16 Oct 2013 15:01:59 -0700
Message-Id: <1381960919-4542-4-git-send-email-jlieb@panasas.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a temporary while waiting for syscall number assignment.

Signed-off-by: Jim Lieb <jlieb@panasas.com>
---
 arch/x86/syscalls/syscall_64.tbl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65d..f46b75c 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	switch_creds		sys_switch_creds
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.8.3.1

