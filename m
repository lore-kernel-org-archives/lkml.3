Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbaDJN5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:57:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39190 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934843AbaDJNxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:53:54 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 3/7] pinctrl: sunxi: add PL and PM pin definitions
Date: Thu, 10 Apr 2014 15:52:42 +0200
Message-Id: <1397137966-30818-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define PL and PM pin macros.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.h | 68 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index 552b0e9..ed3c4d7 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -25,6 +25,8 @@
 #define PG_BASE	192
 #define PH_BASE	224
 #define PI_BASE	256
+#define PL_BASE	352
+#define PM_BASE	384
 
 #define SUNXI_PINCTRL_PIN_PA0	PINCTRL_PIN(PA_BASE + 0, "PA0")
 #define SUNXI_PINCTRL_PIN_PA1	PINCTRL_PIN(PA_BASE + 1, "PA1")
@@ -323,6 +325,72 @@
 #define SUNXI_PINCTRL_PIN_PI30	PINCTRL_PIN(PI_BASE + 30, "PI30")
 #define SUNXI_PINCTRL_PIN_PI31	PINCTRL_PIN(PI_BASE + 31, "PI31")
 
+#define SUNXI_PINCTRL_PIN_PL0	PINCTRL_PIN(PL_BASE + 0, "PL0")
+#define SUNXI_PINCTRL_PIN_PL1	PINCTRL_PIN(PL_BASE + 1, "PL1")
+#define SUNXI_PINCTRL_PIN_PL2	PINCTRL_PIN(PL_BASE + 2, "PL2")
+#define SUNXI_PINCTRL_PIN_PL3	PINCTRL_PIN(PL_BASE + 3, "PL3")
+#define SUNXI_PINCTRL_PIN_PL4	PINCTRL_PIN(PL_BASE + 4, "PL4")
+#define SUNXI_PINCTRL_PIN_PL5	PINCTRL_PIN(PL_BASE + 5, "PL5")
+#define SUNXI_PINCTRL_PIN_PL6	PINCTRL_PIN(PL_BASE + 6, "PL6")
+#define SUNXI_PINCTRL_PIN_PL7	PINCTRL_PIN(PL_BASE + 7, "PL7")
+#define SUNXI_PINCTRL_PIN_PL8	PINCTRL_PIN(PL_BASE + 8, "PL8")
+#define SUNXI_PINCTRL_PIN_PL9	PINCTRL_PIN(PL_BASE + 9, "PL9")
+#define SUNXI_PINCTRL_PIN_PL10	PINCTRL_PIN(PL_BASE + 10, "PL10")
+#define SUNXI_PINCTRL_PIN_PL11	PINCTRL_PIN(PL_BASE + 11, "PL11")
+#define SUNXI_PINCTRL_PIN_PL12	PINCTRL_PIN(PL_BASE + 12, "PL12")
+#define SUNXI_PINCTRL_PIN_PL13	PINCTRL_PIN(PL_BASE + 13, "PL13")
+#define SUNXI_PINCTRL_PIN_PL14	PINCTRL_PIN(PL_BASE + 14, "PL14")
+#define SUNXI_PINCTRL_PIN_PL15	PINCTRL_PIN(PL_BASE + 15, "PL15")
+#define SUNXI_PINCTRL_PIN_PL16	PINCTRL_PIN(PL_BASE + 16, "PL16")
+#define SUNXI_PINCTRL_PIN_PL17	PINCTRL_PIN(PL_BASE + 17, "PL17")
+#define SUNXI_PINCTRL_PIN_PL18	PINCTRL_PIN(PL_BASE + 18, "PL18")
+#define SUNXI_PINCTRL_PIN_PL19	PINCTRL_PIN(PL_BASE + 19, "PL19")
+#define SUNXI_PINCTRL_PIN_PL20	PINCTRL_PIN(PL_BASE + 20, "PL20")
+#define SUNXI_PINCTRL_PIN_PL21	PINCTRL_PIN(PL_BASE + 21, "PL21")
+#define SUNXI_PINCTRL_PIN_PL22	PINCTRL_PIN(PL_BASE + 22, "PL22")
+#define SUNXI_PINCTRL_PIN_PL23	PINCTRL_PIN(PL_BASE + 23, "PL23")
+#define SUNXI_PINCTRL_PIN_PL24	PINCTRL_PIN(PL_BASE + 24, "PL24")
+#define SUNXI_PINCTRL_PIN_PL25	PINCTRL_PIN(PL_BASE + 25, "PL25")
+#define SUNXI_PINCTRL_PIN_PL26	PINCTRL_PIN(PL_BASE + 26, "PL26")
+#define SUNXI_PINCTRL_PIN_PL27	PINCTRL_PIN(PL_BASE + 27, "PL27")
+#define SUNXI_PINCTRL_PIN_PL28	PINCTRL_PIN(PL_BASE + 28, "PL28")
+#define SUNXI_PINCTRL_PIN_PL29	PINCTRL_PIN(PL_BASE + 29, "PL29")
+#define SUNXI_PINCTRL_PIN_PL30	PINCTRL_PIN(PL_BASE + 30, "PL30")
+#define SUNXI_PINCTRL_PIN_PL31	PINCTRL_PIN(PL_BASE + 31, "PL31")
+
+#define SUNXI_PINCTRL_PIN_PM0	PINCTRL_PIN(PM_BASE + 0, "PM0")
+#define SUNXI_PINCTRL_PIN_PM1	PINCTRL_PIN(PM_BASE + 1, "PM1")
+#define SUNXI_PINCTRL_PIN_PM2	PINCTRL_PIN(PM_BASE + 2, "PM2")
+#define SUNXI_PINCTRL_PIN_PM3	PINCTRL_PIN(PM_BASE + 3, "PM3")
+#define SUNXI_PINCTRL_PIN_PM4	PINCTRL_PIN(PM_BASE + 4, "PM4")
+#define SUNXI_PINCTRL_PIN_PM5	PINCTRL_PIN(PM_BASE + 5, "PM5")
+#define SUNXI_PINCTRL_PIN_PM6	PINCTRL_PIN(PM_BASE + 6, "PM6")
+#define SUNXI_PINCTRL_PIN_PM7	PINCTRL_PIN(PM_BASE + 7, "PM7")
+#define SUNXI_PINCTRL_PIN_PM8	PINCTRL_PIN(PM_BASE + 8, "PM8")
+#define SUNXI_PINCTRL_PIN_PM9	PINCTRL_PIN(PM_BASE + 9, "PM9")
+#define SUNXI_PINCTRL_PIN_PM10	PINCTRL_PIN(PM_BASE + 10, "PM10")
+#define SUNXI_PINCTRL_PIN_PM11	PINCTRL_PIN(PM_BASE + 11, "PM11")
+#define SUNXI_PINCTRL_PIN_PM12	PINCTRL_PIN(PM_BASE + 12, "PM12")
+#define SUNXI_PINCTRL_PIN_PM13	PINCTRL_PIN(PM_BASE + 13, "PM13")
+#define SUNXI_PINCTRL_PIN_PM14	PINCTRL_PIN(PM_BASE + 14, "PM14")
+#define SUNXI_PINCTRL_PIN_PM15	PINCTRL_PIN(PM_BASE + 15, "PM15")
+#define SUNXI_PINCTRL_PIN_PM16	PINCTRL_PIN(PM_BASE + 16, "PM16")
+#define SUNXI_PINCTRL_PIN_PM17	PINCTRL_PIN(PM_BASE + 17, "PM17")
+#define SUNXI_PINCTRL_PIN_PM18	PINCTRL_PIN(PM_BASE + 18, "PM18")
+#define SUNXI_PINCTRL_PIN_PM19	PINCTRL_PIN(PM_BASE + 19, "PM19")
+#define SUNXI_PINCTRL_PIN_PM20	PINCTRL_PIN(PM_BASE + 20, "PM20")
+#define SUNXI_PINCTRL_PIN_PM21	PINCTRL_PIN(PM_BASE + 21, "PM21")
+#define SUNXI_PINCTRL_PIN_PM22	PINCTRL_PIN(PM_BASE + 22, "PM22")
+#define SUNXI_PINCTRL_PIN_PM23	PINCTRL_PIN(PM_BASE + 23, "PM23")
+#define SUNXI_PINCTRL_PIN_PM24	PINCTRL_PIN(PM_BASE + 24, "PM24")
+#define SUNXI_PINCTRL_PIN_PM25	PINCTRL_PIN(PM_BASE + 25, "PM25")
+#define SUNXI_PINCTRL_PIN_PM26	PINCTRL_PIN(PM_BASE + 26, "PM26")
+#define SUNXI_PINCTRL_PIN_PM27	PINCTRL_PIN(PM_BASE + 27, "PM27")
+#define SUNXI_PINCTRL_PIN_PM28	PINCTRL_PIN(PM_BASE + 28, "PM28")
+#define SUNXI_PINCTRL_PIN_PM29	PINCTRL_PIN(PM_BASE + 29, "PM29")
+#define SUNXI_PINCTRL_PIN_PM30	PINCTRL_PIN(PM_BASE + 30, "PM30")
+#define SUNXI_PINCTRL_PIN_PM31	PINCTRL_PIN(PM_BASE + 31, "PM31")
+
 #define SUNXI_PIN_NAME_MAX_LEN	5
 
 #define BANK_MEM_SIZE		0x24
-- 
1.8.3.2

