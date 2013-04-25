Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3DYJZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:25:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab3DYJZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:25:00 -0400
Subject: [PATCH] x86, setup: Drop unneeded include <asm/dmi.h>
From: Jean Delvare <jdelvare@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 25 Apr 2013 11:24:05 +0200
Message-ID: <1366881845.4186.65.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/setup.c includes <asm/dmi.h> but it doesn't look like
it needs it, <linux/dmi.h> is sufficient.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-3.9-rc8.orig/arch/x86/kernel/setup.c	2013-04-23 14:30:49.473149298 +0200
+++ linux-3.9-rc8/arch/x86/kernel/setup.c	2013-04-23 14:41:45.666427600 +0200
@@ -82,7 +82,6 @@
 #include <asm/timer.h>
 #include <asm/i8259.h>
 #include <asm/sections.h>
-#include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/setup_arch.h>

-- 
Jean Delvare
Suse L3

