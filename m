Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbaJUUrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:47:14 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44022 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562AbaJUUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:47:08 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH 3/4] vfs: Export new vector IO syscalls (with flags) to userland
Date: Tue, 21 Oct 2014 16:46:58 -0400
Message-Id: <e43b43c1e7b14b454b6425a650cd45cbb75fd325.1413923420.git.milosz@adfin.com>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <cover.1413923420.git.milosz@adfin.com>
References: <cover.1413923420.git.milosz@adfin.com>
In-Reply-To: <cover.1413923420.git.milosz@adfin.com>
References: <cover.1413923420.git.milosz@adfin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only for x86_64 and x86. Will add other arch later.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 arch/x86/syscalls/syscall_32.tbl | 2 ++
 arch/x86/syscalls/syscall_64.tbl | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 9fe1b5d..d592d87 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,5 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	preadv2			sys_preadv2
+359	i386	pwritev2		sys_pwritev2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 281150b..7be2447 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,8 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	64	preadv2			sys_preadv2
+323	64	pwritev2		sys_pwritev2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
1.9.1

