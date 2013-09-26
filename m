Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3IZSyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:54:53 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44450 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3IZSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:29 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 12/21] x86: add necessary includes for prom.h
Date: Thu, 26 Sep 2013 13:50:47 -0500
Message-Id: <1380221456-11192-13-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Once prom.h is no longer implicitly included, we need to include setup.h
to get COMMAND_LINE_SIZE.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/devicetree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 376dc78..c321a78 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -20,6 +20,7 @@
 #include <asm/hpet.h>
 #include <asm/apic.h>
 #include <asm/pci_x86.h>
+#include <asm/setup.h>
 
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
-- 
1.8.1.2

