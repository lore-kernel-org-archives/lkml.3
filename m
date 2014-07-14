Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaGNPLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:11:03 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48572 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaGNPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:35 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 32/38] sh: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:09:00 +0200
Message-Id: <1405350546-28467-32-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sh/include/uapi/asm/Kbuild | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/sh/include/uapi/asm/Kbuild b/arch/sh/include/uapi/asm/Kbuild
index 60613ae..826b88a 100644
--- a/arch/sh/include/uapi/asm/Kbuild
+++ b/arch/sh/include/uapi/asm/Kbuild
@@ -1,25 +1,13 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += auxvec.h
-header-y += byteorder.h
 header-y += cachectl.h
 header-y += cpu-features.h
 header-y += hw_breakpoint.h
-header-y += ioctls.h
-header-y += posix_types.h
 header-y += posix_types_32.h
 header-y += posix_types_64.h
-header-y += ptrace.h
 header-y += ptrace_32.h
 header-y += ptrace_64.h
-header-y += setup.h
-header-y += sigcontext.h
-header-y += signal.h
 header-y += sockios.h
-header-y += stat.h
-header-y += swab.h
-header-y += types.h
-header-y += unistd.h
 header-y += unistd_32.h
 header-y += unistd_64.h
-- 
1.9.3

