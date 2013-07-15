Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab3GOP61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:58:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab3GOP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:58:26 -0400
Message-ID: <51E41BF4.9060602@infradead.org>
Date: Mon, 15 Jul 2013 08:57:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
CC: Florian Fainelli <ffainelli@freebox.fr>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH] x86: fix ce4100.c build errors on i386
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors on i386:

arch/x86/platform/ce4100/ce4100.c:165:2: error: 'reboot_type' undeclared (first use in this function)
arch/x86/platform/ce4100/ce4100.c:165:16: error: 'BOOT_KBD' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: x86@kernel.org
Cc: Florian Fainelli <ffainelli@freebox.fr>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Maxime Bizon <mbizon@freebox.fr>
---
 arch/x86/platform/ce4100/ce4100.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130715.orig/arch/x86/platform/ce4100/ce4100.c
+++ linux-next-20130715/arch/x86/platform/ce4100/ce4100.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/reboot.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
 
