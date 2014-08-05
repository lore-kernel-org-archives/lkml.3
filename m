Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaHEFnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:43:16 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:56793 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbaHEFnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:43:14 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: [PATCH] kbuild: trivial - fix the help doc of CONFIG_CC_OPTIMIZE_FOR_SIZE
Date: Tue,  5 Aug 2014 14:43:07 +0900
Message-Id: <1407217387-23479-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than GCC, we have another choice, Clang for building the kernel
these days.  It seems better to say "compiler" rather than "gcc".

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---
 init/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 41066e4..7bc7c05 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1259,8 +1259,8 @@ endif
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
-	  Enabling this option will pass "-Os" instead of "-O2" to gcc
-	  resulting in a smaller kernel.
+	  Enabling this option will pass "-Os" instead of "-O2" to
+	  your compiler resulting in a smaller kernel.
 
 	  If unsure, say N.
 
-- 
1.9.1

