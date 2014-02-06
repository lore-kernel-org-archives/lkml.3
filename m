Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaBFFZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:25:46 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52032 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaBFFZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:25:45 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: davinci: fix typo
Date: Thu,  6 Feb 2014 10:55:35 +0530
Message-Id: <1391664335-4752-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes a typo in mach/hardware.h, by
replacing "ths" to "this".

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/include/mach/hardware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/include/mach/hardware.h b/arch/arm/mach-davinci/include/mach/hardware.h
index 16bb422..8a5d843 100644
--- a/arch/arm/mach-davinci/include/mach/hardware.h
+++ b/arch/arm/mach-davinci/include/mach/hardware.h
@@ -12,7 +12,7 @@
 #define __ASM_ARCH_HARDWARE_H
 
 /*
- * Before you add anything to ths file:
+ * Before you add anything to this file:
  *
  * This header is for defines common to ALL DaVinci family chips.
  * Anything that is chip specific should go in <chipname>.h,
-- 
1.7.9.5

