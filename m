Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3GNO2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 10:28:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49924 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab3GNO2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 10:28:19 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: keystone: drop "select HAVE_SCHED_CLOCK"
Thread-Topic: [PATCH] ARM: keystone: drop "select HAVE_SCHED_CLOCK"
Thread-Index: AQHOgH48Xr1X7lr0B06gFJYFwc+pW5lkO0xs
Date: Sun, 14 Jul 2013 14:27:38 +0000
Message-ID: <448912EABC71F84BBCADFD3C67C4BE52826E9F@DBDE04.ent.ti.com>
References: <1373798285.1370.2.camel@x61.thuisdomein>
In-Reply-To: <1373798285.1370.2.camel@x61.thuisdomein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top posting. Thanks for the patch. I will pick this up.

Regards,
Santosh
________________________________________
From: Paul Bolle [pebolle@tiscali.nl]
Sent: Sunday, July 14, 2013 6:38 AM
To: Russell King
Cc: Olof Johansson; Shilimkar, Santosh; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: keystone: drop "select HAVE_SCHED_CLOCK"

The Kconfig symbol HAVE_SCHED_CLOCK got removed in v3.4,
with commit 6905a65879b5 ("ARM: Make the sched_clock
framework mandatory"). But a select statement for it popped up again
through commit 828989ad87af ("ARM: keystone: Add minimal TI Keystone
platform support"). Drop that statement, as it is useless.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not tested.

 arch/arm/mach-keystone/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
index 51a50e9..366d1a3 100644
--- a/arch/arm/mach-keystone/Kconfig
+++ b/arch/arm/mach-keystone/Kconfig
@@ -7,7 +7,6 @@ config ARCH_KEYSTONE
        select HAVE_SMP
        select CLKSRC_MMIO
        select GENERIC_CLOCKEVENTS
-       select HAVE_SCHED_CLOCK
        select ARCH_WANT_OPTIONAL_GPIOLIB
        select ARM_ERRATA_798181 if SMP
        help
--
1.8.1.4

