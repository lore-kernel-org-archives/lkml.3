Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab3CVNg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:36:59 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59607 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab3CVNgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:36:17 -0400
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: [PATCH v9 10/11] clk: Kconfig for Palmas clock driver
Date: Fri, 22 Mar 2013 13:36:12 +0000
Message-Id: <1363959373-10671-11-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363959373-10671-1-git-send-email-ian@slimlogic.co.uk>
References: <1363959373-10671-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/clk/Kconfig  |    8 ++++++++
 drivers/clk/Makefile |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index a47e6ee..a8e0655 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -63,6 +63,14 @@ config CLK_TWL6040
 	  McPDM. McPDM module is using the external bit clock on the McPDM bus
 	  as functional clock.
 
+config CLK_PALMAS
+	tristate "Palmas PMIC Clock Support"
+	depends on MFD_PALMAS
+	---help---
+	  Enable clock support for the two clocks on Palmas PMIC chips:
+	  - A 32KHz audio-gated clock (primarily for audio devices)
+	  - A digitally-gated 32KHz clock
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 0147022..34f8d97 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
 obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
+obj-$(CONFIG_CLK_PALMAS)	+= clk-palmas.o
-- 
1.7.0.4

