Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3DALe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:34:26 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45042 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab3DALeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:34:25 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Heiko Schocher <hs@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matt Porter <mporter@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: daVinci: remove __init modifier from function declaration
Date: Mon,  1 Apr 2013 17:03:36 +0530
Message-Id: <1364816016-29656-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes the __init modifier from function declaration
of all the header files for davinci platform.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/davinci.h                |   28 ++++++++++++------------
 arch/arm/mach-davinci/include/mach/cp_intc.h   |    4 +-
 arch/arm/mach-davinci/include/mach/da8xx.h     |   16 ++++++------
 arch/arm/mach-davinci/include/mach/tnetv107x.h |    6 ++--
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
index 12d544b..97e74ca 100644
--- a/arch/arm/mach-davinci/davinci.h
+++ b/arch/arm/mach-davinci/davinci.h
@@ -70,32 +70,32 @@ void davinci_map_sysmod(void);
 #define DM646X_ASYNC_EMIF_CS2_SPACE_BASE 0x42000000
 
 /* DM355 function declarations */
-void __init dm355_init(void);
+void dm355_init(void);
 void dm355_init_spi0(unsigned chipselect_mask,
 		const struct spi_board_info *info, unsigned len);
-void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
+void dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
 void dm355_set_vpfe_config(struct vpfe_config *cfg);
 
 /* DM365 function declarations */
-void __init dm365_init(void);
-void __init dm365_init_asp(struct snd_platform_data *pdata);
-void __init dm365_init_vc(struct snd_platform_data *pdata);
-void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
-void __init dm365_init_rtc(void);
+void dm365_init(void);
+void dm365_init_asp(struct snd_platform_data *pdata);
+void dm365_init_vc(struct snd_platform_data *pdata);
+void dm365_init_ks(struct davinci_ks_platform_data *pdata);
+void dm365_init_rtc(void);
 void dm365_init_spi0(unsigned chipselect_mask,
 			const struct spi_board_info *info, unsigned len);
 void dm365_set_vpfe_config(struct vpfe_config *cfg);
 
 /* DM644x function declarations */
-void __init dm644x_init(void);
-void __init dm644x_init_asp(struct snd_platform_data *pdata);
-int __init dm644x_init_video(struct vpfe_config *, struct vpbe_config *);
+void dm644x_init(void);
+void dm644x_init_asp(struct snd_platform_data *pdata);
+int dm644x_init_video(struct vpfe_config *, struct vpbe_config *);
 
 /* DM646x function declarations */
-void __init dm646x_init(void);
-void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
-void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
-int __init dm646x_init_edma(struct edma_rsv_info *rsv);
+void dm646x_init(void);
+void dm646x_init_mcasp0(struct snd_platform_data *pdata);
+void dm646x_init_mcasp1(struct snd_platform_data *pdata);
+int dm646x_init_edma(struct edma_rsv_info *rsv);
 void dm646x_video_init(void);
 void dm646x_setup_vpif(struct vpif_display_config *,
 		       struct vpif_capture_config *);
diff --git a/arch/arm/mach-davinci/include/mach/cp_intc.h b/arch/arm/mach-davinci/include/mach/cp_intc.h
index d13d8df..827bbe9 100644
--- a/arch/arm/mach-davinci/include/mach/cp_intc.h
+++ b/arch/arm/mach-davinci/include/mach/cp_intc.h
@@ -51,7 +51,7 @@
 #define CP_INTC_HOST_PRIO_VECTOR(n)	(0x1600 + (n << 2))
 #define CP_INTC_VECTOR_ADDR(n)		(0x2000 + (n << 2))
 
-void __init cp_intc_init(void);
-int __init cp_intc_of_init(struct device_node *, struct device_node *);
+void cp_intc_init(void);
+int cp_intc_of_init(struct device_node *, struct device_node *);
 
 #endif	/* __ASM_HARDWARE_CP_INTC_H */
diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
index de439b7..dad6705 100644
--- a/arch/arm/mach-davinci/include/mach/da8xx.h
+++ b/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -76,8 +76,8 @@ extern unsigned int da850_max_speed;
 #define DA8XX_SHARED_RAM_BASE	0x80000000
 #define DA8XX_ARM_RAM_BASE	0xffff0000
 
-void __init da830_init(void);
-void __init da850_init(void);
+void da830_init(void);
+void da850_init(void);
 
 int da830_register_edma(struct edma_rsv_info *rsv);
 int da850_register_edma(struct edma_rsv_info *rsv[2]);
@@ -91,17 +91,17 @@ int da8xx_register_uio_pruss(void);
 int da8xx_register_lcdc(struct da8xx_lcdc_platform_data *pdata);
 int da8xx_register_mmcsd0(struct davinci_mmc_config *config);
 int da850_register_mmcsd1(struct davinci_mmc_config *config);
-void __init da8xx_register_mcasp(int id, struct snd_platform_data *pdata);
+void da8xx_register_mcasp(int id, struct snd_platform_data *pdata);
 int da8xx_register_rtc(void);
 int da850_register_cpufreq(char *async_clk);
 int da8xx_register_cpuidle(void);
-void __iomem * __init da8xx_get_mem_ctlr(void);
+void __iomem *da8xx_get_mem_ctlr(void);
 int da850_register_pm(struct platform_device *pdev);
-int __init da850_register_sata(unsigned long refclkpn);
-int __init da850_register_vpif(void);
-int __init da850_register_vpif_display
+int da850_register_sata(unsigned long refclkpn);
+int da850_register_vpif(void);
+int da850_register_vpif_display
 			(struct vpif_display_config *display_config);
-int __init da850_register_vpif_capture
+int da850_register_vpif_capture
 			(struct vpif_capture_config *capture_config);
 void da8xx_restart(char mode, const char *cmd);
 
diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/mach-davinci/include/mach/tnetv107x.h
index 1656a02..366e975 100644
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
+++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
@@ -51,9 +51,9 @@ struct tnetv107x_device_info {
 extern struct platform_device tnetv107x_wdt_device;
 extern struct platform_device tnetv107x_serial_device;
 
-extern void __init tnetv107x_init(void);
-extern void __init tnetv107x_devices_init(struct tnetv107x_device_info *);
-extern void __init tnetv107x_irq_init(void);
+extern void tnetv107x_init(void);
+extern void tnetv107x_devices_init(struct tnetv107x_device_info *);
+extern void tnetv107x_irq_init(void);
 void tnetv107x_restart(char mode, const char *cmd);
 
 #endif
-- 
1.7.4.1

