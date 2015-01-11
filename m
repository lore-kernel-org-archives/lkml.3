Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbbAKCAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 21:00:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47636 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbbAKCAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 21:00:34 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] avr32: remove fake at91 cpu identification
Date: Sun, 11 Jan 2015 03:00:16 +0100
Message-Id: <1420941616-2777-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_is_at91* are not used in any driver outside mach-at91. Remove those useless
definitions.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

Hans-Christian,

If you want, I guess that one could go through the at91 tree. Unless you have
more material and you want to do a pull request for 3.20.

Regards,

 arch/avr32/mach-at32ap/include/mach/cpu.h | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
index 16a24b14146c..4181086f4ddc 100644
--- a/arch/avr32/mach-at32ap/include/mach/cpu.h
+++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
@@ -1,5 +1,5 @@
 /*
- * AVR32 and (fake) AT91 CPU identification
+ * AVR32 CPU identification
  *
  * Copyright (C) 2007 Atmel Corporation
  *
@@ -20,28 +20,4 @@
 # define cpu_is_at32ap7000()	(0)
 #endif
 
-/*
- * Since this is AVR32, we will never run on any AT91 CPU. But these
- * definitions may reduce clutter in common drivers.
- */
-#define cpu_is_at91rm9200()	(0)
-#define cpu_is_at91sam9xe()	(0)
-#define cpu_is_at91sam9260()	(0)
-#define cpu_is_at91sam9261()	(0)
-#define cpu_is_at91sam9263()	(0)
-#define cpu_is_at91sam9rl()	(0)
-#define cpu_is_at91sam9g10()	(0)
-#define cpu_is_at91sam9g20()	(0)
-#define cpu_is_at91sam9g45()	(0)
-#define cpu_is_at91sam9g45es()	(0)
-#define cpu_is_at91sam9m10()	(0)
-#define cpu_is_at91sam9g46()	(0)
-#define cpu_is_at91sam9m11()	(0)
-#define cpu_is_at91sam9x5()	(0)
-#define cpu_is_at91sam9g15()	(0)
-#define cpu_is_at91sam9g35()	(0)
-#define cpu_is_at91sam9x35()	(0)
-#define cpu_is_at91sam9g25()	(0)
-#define cpu_is_at91sam9x25()	(0)
-
 #endif /* __ASM_ARCH_CPU_H */
-- 
2.1.0

