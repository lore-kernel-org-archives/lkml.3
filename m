Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152Ab3ECLCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:02:09 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38894 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760924Ab3ECLCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:02:07 -0400
From: Daniel Baluta <dbaluta@ixiacom.com>
To: lguest@lists.ozlabs.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH v2] lguest: rename i386_head.S
Date: Fri,  3 May 2013 14:01:57 +0300
Message-Id: <1367578917-21083-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9a163ed8e0 (i386: move kernel) kernel/i386_head.S
was renamed to kernel/head_32.S. We do the same for lguest/i386_head.S.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
Changes since v1:
	* use head_32.o in Makefile

 arch/x86/lguest/Makefile                   |    2 +-
 arch/x86/lguest/{i386_head.S => head_32.S} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/x86/lguest/{i386_head.S => head_32.S} (100%)

diff --git a/arch/x86/lguest/Makefile b/arch/x86/lguest/Makefile
index 94e0e54..8f38d57 100644
--- a/arch/x86/lguest/Makefile
+++ b/arch/x86/lguest/Makefile
@@ -1,2 +1,2 @@
-obj-y		:= i386_head.o boot.o
+obj-y		:= head_32.o boot.o
 CFLAGS_boot.o	:= $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/head_32.S
similarity index 100%
rename from arch/x86/lguest/i386_head.S
rename to arch/x86/lguest/head_32.S
-- 
1.7.5.4

