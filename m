Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab3JPWC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:02:57 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50199 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761039Ab3JPWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:02:35 -0400
From: Jim Lieb <jlieb@panasas.com>
To: tytso@mit.edu, viro@zeniv.linux.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com, Jim Lieb <jlieb@panasas.com>
Subject: [PATCH 2/3] switch_creds: Add x86 syscall number
Date: Wed, 16 Oct 2013 15:01:58 -0700
Message-Id: <1381960919-4542-3-git-send-email-jlieb@panasas.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is temporary number awaiting syscall number assignment.

Signed-off-by: Jim Lieb <jlieb@panasas.com>
---
 arch/x86/syscalls/syscall_32.tbl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index aabfb83..b836839 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,4 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	switch_creds		sys_switch_creds
-- 
1.8.3.1

