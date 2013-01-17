Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3AQLeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:34:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47497 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3AQLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:31:42 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 20/22] ARM: OMAP4: clock data: get rid of unused USB host clock aliases
Date: Thu, 17 Jan 2013 13:30:29 +0200
Message-ID: <1358422231-24736-21-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358422231-24736-1-git-send-email-rogerq@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need multiple aliases for the OMAP USB host clocks so remove them.

CC: Paul Walmsley <paul@pwsan.com>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>
CC: Mike Turquette <mturquette@linaro.org>

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/cclock44xx_data.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 5789a5e..5ee78f3 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -1875,7 +1875,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart3_fck",			&uart3_fck,	CK_443X),
 	CLK(NULL,	"uart4_fck",			&uart4_fck,	CK_443X),
 	CLK(NULL,	"usb_host_fs_fck",		&usb_host_fs_fck,	CK_443X),
-	CLK("usbhs_omap",	"fs_fck",		&usb_host_fs_fck,	CK_443X),
 	CLK(NULL,	"utmi_p1_gfclk",		&utmi_p1_gfclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&usb_host_hs_utmi_p1_clk,	CK_443X),
 	CLK(NULL,	"utmi_p2_gfclk",		&utmi_p2_gfclk,	CK_443X),
@@ -1887,7 +1886,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_host_hs_hsic480m_p2_clk",	&usb_host_hs_hsic480m_p2_clk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_func48mclk",	&usb_host_hs_func48mclk,	CK_443X),
 	CLK(NULL,	"usb_host_hs_fck",		&usb_host_hs_fck,	CK_443X),
-	CLK("usbhs_omap",	"hs_fck",		&usb_host_hs_fck,	CK_443X),
 	CLK(NULL,	"otg_60m_gfclk",		&otg_60m_gfclk,	CK_443X),
 	CLK(NULL,	"usb_otg_hs_xclk",		&usb_otg_hs_xclk,	CK_443X),
 	CLK(NULL,	"usb_otg_hs_ick",		&usb_otg_hs_ick,	CK_443X),
@@ -1897,8 +1895,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"usb_tll_hs_usb_ch0_clk",	&usb_tll_hs_usb_ch0_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_usb_ch1_clk",	&usb_tll_hs_usb_ch1_clk,	CK_443X),
 	CLK(NULL,	"usb_tll_hs_ick",		&usb_tll_hs_ick,	CK_443X),
-	CLK("usbhs_omap",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
-	CLK("usbhs_tll",	"usbtll_ick",		&usb_tll_hs_ick,	CK_443X),
 	CLK(NULL,	"usim_ck",			&usim_ck,	CK_443X),
 	CLK(NULL,	"usim_fclk",			&usim_fclk,	CK_443X),
 	CLK(NULL,	"usim_fck",			&usim_fck,	CK_443X),
@@ -1949,9 +1945,6 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK(NULL,	"uart2_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart3_ick",			&dummy_ck,	CK_443X),
 	CLK(NULL,	"uart4_ick",			&dummy_ck,	CK_443X),
-	CLK("usbhs_omap",	"usbhost_ick",		&dummy_ck,		CK_443X),
-	CLK("usbhs_omap",	"usbtll_fck",		&dummy_ck,	CK_443X),
-	CLK("usbhs_tll",	"usbtll_fck",		&dummy_ck,	CK_443X),
 	CLK("omap_wdt",	"ick",				&dummy_ck,	CK_443X),
 	CLK(NULL,	"timer_32k_ck",	&sys_32k_ck,	CK_443X),
 	/* TODO: Remove "omap_timer.X" aliases once DT migration is complete */
-- 
1.7.4.1

