Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486AbaGXJrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421AbaGXJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/128] Score: Modify the Makefile of Score, remove -mlong-calls for compiling
Date: Thu, 24 Jul 2014 10:44:58 +0100
Message-Id: <1406195177-8656-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit df9e4d1c39c472cb44d81ab2ed2db503fc486e3b upstream.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/score/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/score/Makefile b/arch/score/Makefile
index 974aefe86123..9e3e060290e0 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -20,8 +20,8 @@ cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
 #
 KBUILD_AFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(cflags-y)
-KBUILD_AFLAGS_MODULE += -mlong-calls
-KBUILD_CFLAGS_MODULE += -mlong-calls
+KBUILD_AFLAGS_MODULE +=
+KBUILD_CFLAGS_MODULE +=
 LDFLAGS += --oformat elf32-littlescore
 LDFLAGS_vmlinux	+= -G0 -static -nostdlib
 
-- 
1.9.1

