Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3GJTv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:51:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57019 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3GJTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:51:58 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Add Daniel as maintainer for CLOCKSOURCE and CLOCKEVENT Drivers
Date: Wed, 10 Jul 2013 20:51:54 +0100
Message-Id: <1373485914-16398-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing a bad job at managing the drivers/clocksource directory,
so Daniel has been helping with review and patch queuing for the clocksource
and clockevent drivers, so add him formally to the MAINTAINERS list.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 MAINTAINERS | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e626794..5964b68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2090,6 +2090,13 @@ M:	Russell King <linux@arm.linux.org.uk>
 S:	Maintained
 F:	include/linux/clk.h
 
+CLOCKSOURCE, CLOCKEVENT DRIVERS
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
+S:	Supported
+F:	drivers/clocksource
+
 CISCO FCOE HBA DRIVER
 M:	Hiral Patel <hiralpat@cisco.com>
 M:	Suma Ramars <sramars@cisco.com>
@@ -7021,7 +7028,7 @@ S:	Maintained
 F:	include/linux/mmc/dw_mmc.h
 F:	drivers/mmc/host/dw_mmc*
 
-TIMEKEEPING, NTP
+TIMEKEEPING, CLOCKSOURCE CORE, NTP
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
@@ -7034,7 +7041,6 @@ F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
-F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
-- 
1.8.1.2

