Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaDXIoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:44:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaDXIoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:44:07 -0400
Date: Thu, 24 Apr 2014 10:44:04 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: Add a Kconfig menu
Message-ID: <20140424104404.5e7aeafa@endymion.delvare>
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
 drivers/clocksource/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-3.15-rc2.orig/drivers/clocksource/Kconfig	2014-04-14 09:42:29.638069013 +0200
+++ linux-3.15-rc2/drivers/clocksource/Kconfig	2014-04-24 10:35:47.663624163 +0200
@@ -1,3 +1,5 @@
+menu "Clock Source drivers"
+
 config CLKSRC_OF
 	bool
 
@@ -191,3 +193,5 @@ config EM_TIMER_STI
 
 config CLKSRC_QCOM
 	bool
+
+endmenu


-- 
Jean Delvare
SUSE L3 Support
