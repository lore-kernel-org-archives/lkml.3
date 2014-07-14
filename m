Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaGNPKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:10:48 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48592 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbaGNPJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:36 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 35/38] unicore32: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:09:03 +0200
Message-Id: <1405350546-28467-35-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/uapi/asm/Kbuild | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/unicore32/include/uapi/asm/Kbuild b/arch/unicore32/include/uapi/asm/Kbuild
index 0514d7a..aff532f 100644
--- a/arch/unicore32/include/uapi/asm/Kbuild
+++ b/arch/unicore32/include/uapi/asm/Kbuild
@@ -1,10 +1,5 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += byteorder.h
-header-y += kvm_para.h
-header-y += ptrace.h
-header-y += sigcontext.h
-header-y += unistd.h
-
+# Wapper from asm-generic
 generic-y += kvm_para.h
-- 
1.9.3

