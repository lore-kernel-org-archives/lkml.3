Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaGNPRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:17:42 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48404 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaGNPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:24 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 13/38] arm64: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:41 +0200
Message-Id: <1405350546-28467-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/uapi/asm/Kbuild | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index 942376d..aa17aa8 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -1,21 +1,5 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-generic-y += kvm_para.h
-
-header-y += auxvec.h
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += fcntl.h
 header-y += hwcap.h
-header-y += kvm_para.h
 header-y += perf_regs.h
-header-y += param.h
-header-y += ptrace.h
-header-y += setup.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += signal.h
-header-y += stat.h
-header-y += statfs.h
-header-y += unistd.h
-- 
1.9.3

