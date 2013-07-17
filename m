Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3GQKF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:05:56 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:32831 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab3GQKFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:05:55 -0400
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 06:05:54 EDT
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] MAINTAINERS: add the generic sched_clock under timekeeping
Date: Wed, 17 Jul 2013 13:05:19 +0300
Message-Id: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..bd9616a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7129,6 +7129,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
 F:	include/linux/clocksource.h
+F:	include/linux/sched_clock.h
 F:	include/linux/time.h
 F:	include/linux/timex.h
 F:	include/uapi/linux/time.h
@@ -7136,6 +7137,7 @@ F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
+F:	kernel/time/sched_clock.c
 F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
-- 
1.8.3.2

