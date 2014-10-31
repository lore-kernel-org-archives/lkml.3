Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbaJaQC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:02:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58982 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJaQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:02:15 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: corbet@lwn.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lcapitulino@redhat.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: vm: Add 1GB large page support information
Date: Sat,  1 Nov 2014 01:01:57 +0900
Message-Id: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.555.gfbecd99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add 1GB large page support information on
x86_64 architecture in Documentation/vm/hugetlbpage.txt.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/vm/hugetlbpage.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index bdd4bb9..0a2bf4f 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -2,7 +2,8 @@
 The intent of this file is to give a brief summary of hugetlbpage support in
 the Linux kernel.  This support is built on top of multiple page size support
 that is provided by most modern architectures.  For example, i386
-architecture supports 4K and 4M (2M in PAE mode) page sizes, ia64
+architecture supports 4K and 4M (2M in PAE mode) page sizes, x86_64
+architecture supports 4K, 2M and 1G (SandyBridge or later) page sizes. ia64
 architecture supports multiple page sizes 4K, 8K, 64K, 256K, 1M, 4M, 16M,
 256M and ppc64 supports 4K and 16M.  A TLB is a cache of virtual-to-physical
 translations.  Typically this is a very scarce resource on processor.
-- 
2.1.2.555.gfbecd99

