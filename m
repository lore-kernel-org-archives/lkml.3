Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaFPJsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:48:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbaFPJst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:48:49 -0400
Date: Mon, 16 Jun 2014 11:48:45 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] clocksource: Add a Kconfig menu
Message-ID: <20140616114845.343e9960@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the clocksource Kconfig entries into their own menu, so that they
don't pollute the main device driver menu.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Patch already sent on 2014-04-24. Changes since v1:
 * Rebased on kernel 3.16-rc1

 drivers/clocksource/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-3.16-rc1.orig/drivers/clocksource/Kconfig	2014-06-16 11:43:35.338280484 +0200
+++ linux-3.16-rc1/drivers/clocksource/Kconfig	2014-06-16 11:45:58.395215728 +0200
@@ -1,3 +1,5 @@
+menu "Clock Source drivers"
+
 config CLKSRC_OF
 	bool
 
@@ -207,3 +209,5 @@ config CLKSRC_VERSATILE
 	  counter available in the "System Registers" block of
 	  ARM Versatile, RealView and Versatile Express reference
 	  platforms.
+
+endmenu


-- 
Jean Delvare
SUSE L3 Support
