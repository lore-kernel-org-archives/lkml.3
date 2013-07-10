Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3GJS1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:27:40 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53305 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3GJS1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:27:39 -0400
Message-ID: <51DDA797.4030200@linaro.org>
Date: Wed, 10 Jul 2013 19:27:35 +0100
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH] MAINTAINERS: Add Daniel as maintainer for drivers/clocksource
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing a bad job at managing the drivers/clocksource directory,
so Daniel has been helping with review and patch queuing for the clocksource
and clockevent drivers, so add him formally to the MAINTAINERS list.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
  MAINTAINERS | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5be702c..460c996 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7014,6 +7014,12 @@ F:	include/uapi/linux/timex.h
  F:	kernel/time/clocksource.c
  F:	kernel/time/time*.c
  F:	kernel/time/ntp.c
+
+CLOCKSOURCE, CLOCKEVENT DRIVERS
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+M:	Thomas Gleixner <tglx@linutronix.de>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
+S:	Supported
  F:	drivers/clocksource
  
  TLG2300 VIDEO4LINUX-2 DRIVER
-- 
1.8.1.2

