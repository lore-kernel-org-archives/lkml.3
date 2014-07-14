Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaGNPOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:14:17 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48453 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaGNPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:28 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 23/38] metag: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:51 +0200
Message-Id: <1405350546-28467-23-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/uapi/asm/Kbuild | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
index ab78be2..1f7f43f 100644
--- a/arch/metag/include/uapi/asm/Kbuild
+++ b/arch/metag/include/uapi/asm/Kbuild
@@ -1,14 +1,9 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += byteorder.h
 header-y += ech.h
-header-y += ptrace.h
-header-y += sigcontext.h
-header-y += siginfo.h
-header-y += swab.h
-header-y += unistd.h
 
+# Wrappers from asm-generic
 generic-y += mman.h
 generic-y += resource.h
 generic-y += setup.h
-- 
1.9.3

