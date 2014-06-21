Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaFUUiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:38:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaFUUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:38:19 -0400
Date: Sat, 21 Jun 2014 13:38:06 -0700
From: tip-bot for Jean Delvare <tipbot@zytor.com>
Message-ID: <tip-58394271c610e9c65dd0165a1c1f6dec75dc5f3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jdelvare@suse.de, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jdelvare@suse.de, daniel.lezcano@linaro.org
In-Reply-To: <20140616114845.343e9960@endymion.delvare>
References: <20140616114845.343e9960@endymion.delvare>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Add a Kconfig menu
Git-Commit-ID: 58394271c610e9c65dd0165a1c1f6dec75dc5f3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58394271c610e9c65dd0165a1c1f6dec75dc5f3e
Gitweb:     http://git.kernel.org/tip/58394271c610e9c65dd0165a1c1f6dec75dc5f3e
Author:     Jean Delvare <jdelvare@suse.de>
AuthorDate: Mon, 16 Jun 2014 11:48:45 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 22:32:42 +0200

clocksource: Add a Kconfig menu

Move the clocksource Kconfig entries into their own menu, so that they
don't pollute the main device driver menu.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: http://lkml.kernel.org/r/20140616114845.343e9960@endymion.delvare
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 065131c..6a11518 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
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
