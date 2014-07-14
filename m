Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaGNPRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:17:06 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48467 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaGNPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:27 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 12/38] arm: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:40 +0200
Message-Id: <1405350546-28467-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/uapi/asm/Kbuild | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/include/uapi/asm/Kbuild b/arch/arm/include/uapi/asm/Kbuild
index 70a1c9d..aa17aa8 100644
--- a/arch/arm/include/uapi/asm/Kbuild
+++ b/arch/arm/include/uapi/asm/Kbuild
@@ -1,19 +1,5 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += byteorder.h
-header-y += fcntl.h
 header-y += hwcap.h
-header-y += ioctls.h
-header-y += kvm_para.h
-header-y += mman.h
 header-y += perf_regs.h
-header-y += posix_types.h
-header-y += ptrace.h
-header-y += setup.h
-header-y += sigcontext.h
-header-y += signal.h
-header-y += stat.h
-header-y += statfs.h
-header-y += swab.h
-header-y += unistd.h
-- 
1.9.3

