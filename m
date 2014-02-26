Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBZBJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:09:19 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45287 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaBZBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:17 -0500
From: behanw@converseincode.com
To: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/5] kbuild: LLVMLinux: Initial updates to kbuild to enable the kernel to be compiled with clang/LLVM
Date: Tue, 25 Feb 2014 17:08:38 -0800
Message-Id: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

These patches add initial support for compiling the x86 kernel with clang. More
patches to the kernel code are required to actually compile the kernel with
clang. The intent of these patches are just to get things started with kbuild.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 


Behan Webster (1):
  kbuild: LLVMLinux: Add Kbuild support for building kernel with Clang

Jan-Simon Möller (3):
  kbuild: LLVMLinux: Adapt warnings for compilation with clang
  kbuild: LLVMLinux: Fix LINUX_COMPILER definition script for
    compilation with clang
  x86 kbuild: LLVMLinux: More cc-options added for clang

Mark Charlebois (1):
  LLVMLinux: Add support for clang to compiler.h and new
    compiler-clang.h

 Makefile                       | 32 +++++++++++++++++++++++++++++++-
 arch/x86/Makefile              |  8 +++++++-
 include/linux/compiler-clang.h | 12 ++++++++++++
 include/linux/compiler.h       |  7 +++++++
 scripts/Makefile.build         | 13 ++++++++++++-
 scripts/mkcompile_h            |  2 +-
 6 files changed, 70 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/compiler-clang.h

-- 
1.8.3.2

