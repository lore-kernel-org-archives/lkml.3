Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3IZSvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:49 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62561 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3IZSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:43 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        James Hogan <james.hogan@imgtec.com>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 21/21] of: remove empty arch prom.h headers
Date: Thu, 26 Sep 2013 13:50:56 -0500
Message-Id: <1380221456-11192-22-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Now that prom.h is optional, all the empty prom.h headers can be removed.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/arc/include/asm/prom.h      | 12 ------------
 arch/arm64/include/asm/prom.h    |  1 -
 arch/c6x/include/asm/prom.h      |  1 -
 arch/metag/include/asm/prom.h    | 20 --------------------
 arch/openrisc/include/asm/prom.h | 20 --------------------
 arch/xtensa/include/asm/prom.h   |  4 ----
 6 files changed, 58 deletions(-)
 delete mode 100644 arch/arc/include/asm/prom.h
 delete mode 100644 arch/arm64/include/asm/prom.h
 delete mode 100644 arch/c6x/include/asm/prom.h
 delete mode 100644 arch/metag/include/asm/prom.h
 delete mode 100644 arch/openrisc/include/asm/prom.h
 delete mode 100644 arch/xtensa/include/asm/prom.h

diff --git a/arch/arc/include/asm/prom.h b/arch/arc/include/asm/prom.h
deleted file mode 100644
index 1555549..0000000
--- a/arch/arc/include/asm/prom.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/*
- * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef _ASM_ARC_PROM_H_
-#define _ASM_ARC_PROM_H_
-
-#endif
diff --git a/arch/arm64/include/asm/prom.h b/arch/arm64/include/asm/prom.h
deleted file mode 100644
index 68b90e6..0000000
--- a/arch/arm64/include/asm/prom.h
+++ /dev/null
@@ -1 +0,0 @@
-/* Empty for now */
diff --git a/arch/c6x/include/asm/prom.h b/arch/c6x/include/asm/prom.h
deleted file mode 100644
index b4ec95f0..0000000
--- a/arch/c6x/include/asm/prom.h
+++ /dev/null
@@ -1 +0,0 @@
-/* dummy prom.h; here to make linux/of.h's #includes happy */
diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
deleted file mode 100644
index d4be144..0000000
--- a/arch/metag/include/asm/prom.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- *  arch/metag/include/asm/prom.h
- *
- *  Copyright (C) 2012 Imagination Technologies Ltd.
- *
- *  Based on ARM version:
- *  Copyright (C) 2009 Canonical Ltd. <jeremy.kerr@canonical.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-#ifndef __ASM_METAG_PROM_H
-#define __ASM_METAG_PROM_H
-
-
-extern void copy_fdt(void);
-
-#endif /* __ASM_METAG_PROM_H */
diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
deleted file mode 100644
index bec477b..0000000
--- a/arch/openrisc/include/asm/prom.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef _ASM_OPENRISC_PROM_H
-#define _ASM_OPENRISC_PROM_H
-
-#endif /* _ASM_OPENRISC_PROM_H */
diff --git a/arch/xtensa/include/asm/prom.h b/arch/xtensa/include/asm/prom.h
deleted file mode 100644
index 2a87a58..0000000
--- a/arch/xtensa/include/asm/prom.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _XTENSA_ASM_PROM_H
-#define _XTENSA_ASM_PROM_H
-
-#endif /* _XTENSA_ASM_PROM_H */
-- 
1.8.1.2

