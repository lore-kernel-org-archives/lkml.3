Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaLYSBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 13:01:04 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35943 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaLYR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:33 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 21/25] MIPS: BMIPS: Use a non-default FIXADDR_TOP setting
Date: Thu, 25 Dec 2014 09:49:16 -0800
Message-Id: <1419529760-9520-22-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be required to support BMIPS3300 platforms.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/mach-bmips/spaces.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 arch/mips/include/asm/mach-bmips/spaces.h

diff --git a/arch/mips/include/asm/mach-bmips/spaces.h b/arch/mips/include/asm/mach-bmips/spaces.h
new file mode 100644
index 0000000..1b05bdd
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/spaces.h
@@ -0,0 +1,18 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03, 04 Ralf Baechle
+ * Copyright (C) 2000, 2002  Maciej W. Rozycki
+ * Copyright (C) 1990, 1999, 2000 Silicon Graphics, Inc.
+ */
+#ifndef _ASM_BMIPS_SPACES_H
+#define _ASM_BMIPS_SPACES_H
+
+/* Avoid collisions with system base register (SBR) region on BMIPS3300 */
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xff000000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_BMIPS_SPACES_H */
-- 
2.1.1

