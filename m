Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaBJB7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:59:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:35489 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBJB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:59:06 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <tony@atomide.com>,
        <egtvedt@samfundet.no>, <linux@prisktech.co.nz>,
        <geert@linux-m68k.org>, <David.Laight@ACULAB.COM>,
        <daniel.lezcano@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <x86@kernel.org>, Yijing Wang <wangyijing@huawei.com>
Subject: [Update][PATCH 1/2] clocksource: Remove outdated comments
Date: Mon, 10 Feb 2014 09:58:13 +0800
Message-ID: <1391997493-42564-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource_register() and __clocksource_register_scale()
always return 0, so the comment is just pointless, it's
outdated, remove it.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 kernel/time/clocksource.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ba3e502..9951575 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -779,8 +779,6 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
- * Returns -EBUSY if registration fails, zero otherwise.
- *
  * This *SHOULD NOT* be called directly! Please use the
  * clocksource_register_hz() or clocksource_register_khz helper functions.
  */
@@ -805,7 +803,6 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
  * clocksource_register - Used to install new clocksources
  * @cs:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
  */
 int clocksource_register(struct clocksource *cs)
 {
-- 
1.7.1


