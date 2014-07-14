Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaGNPOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:14:52 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48491 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaGNPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:27 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 19/38] hexagon: clean-up uapi Kbuild file
Date: Mon, 14 Jul 2014 17:08:47 +0200
Message-Id: <1405350546-28467-19-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant assignments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/include/uapi/asm/Kbuild | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/hexagon/include/uapi/asm/Kbuild b/arch/hexagon/include/uapi/asm/Kbuild
index c31706c..3f464d5 100644
--- a/arch/hexagon/include/uapi/asm/Kbuild
+++ b/arch/hexagon/include/uapi/asm/Kbuild
@@ -1,15 +1,5 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += bitsperlong.h
-header-y += byteorder.h
-header-y += kvm_para.h
-header-y += param.h
-header-y += ptrace.h
 header-y += registers.h
-header-y += setup.h
-header-y += sigcontext.h
-header-y += signal.h
-header-y += swab.h
-header-y += unistd.h
 header-y += user.h
-- 
1.9.3

