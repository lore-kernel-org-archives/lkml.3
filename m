Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3B0ShA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:37:00 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:52458 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760710Ab3B0Sg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:36:59 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org, ldewangan@nvidia.com, j-keerthy@ti.com,
        gg@slimlogic.co.uk, wim@iguana.be, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH 2/2] watchdog: Kconfig for Palmas watchdog driver
Date: Wed, 27 Feb 2013 18:36:08 +0000
Message-Id: <1361990168-882-2-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1361990168-882-1-git-send-email-ian@slimlogic.co.uk>
References: <1361990168-882-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Kconfig and MAkefile for the Palmas Watchdog driver

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/watchdog/Kconfig  |    7 +++++++
 drivers/watchdog/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 0374e0e..dae5a91 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -103,6 +103,13 @@ config WM8350_WATCHDOG
 	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
 	  the watchdog triggers the system will be reset.
 
+config PALMAS_WATCHDOG
+	tristate "Palmas Watchdog"
+	depends on MFD_PALMAS
+	help
+	  Support for the watchdog in the Palmas family of PMICs. When the
+	  watchdog times out system will be reset.
+
 # ALPHA Architecture
 
 # ARM Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index a300b94..e845c21 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -171,3 +171,4 @@ obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
+obj-$(CONFIG_PALMAS_WATCHDOG) += palmas_wdt.o
-- 
1.7.0.4

