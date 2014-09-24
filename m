Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaIXVrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:47:06 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:40223 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIXVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:46:37 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v3 3/4] vfs: Export new vector IO syscalls (with flags) to userland
Date: Wed, 24 Sep 2014 21:46:25 +0000
Message-Id: <3a5bf02940d84f005c591c0038a0ebf293f01fc5.1411594645.git.milosz@adfin.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411594644.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1411594644.git.milosz@adfin.com>
In-Reply-To: <cover.1411594644.git.milosz@adfin.com>
References: <cover.1411594644.git.milosz@adfin.com>
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
index 028b781..fbd98ab 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -363,3 +363,5 @@
 354	i386	seccomp			sys_seccomp
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
+357	i386	preadv2			sys_preadv2
+358	i386	pwritev2		sys_pwritev2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 35dd922..5c91cf6 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -327,6 +327,8 @@
 318	common	getrandom		sys_getrandom
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
+321	64	preadv2			sys_preadv2
+322	64	pwritev2		sys_pwritev2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
2.1.0

