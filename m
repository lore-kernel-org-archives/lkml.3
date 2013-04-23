Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3DWOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:34:33 -0400
Received: from multi.imgtec.com ([194.200.65.239]:40843 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3DWOeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:34:31 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/8] metag: tz1090: add <asm/soc-tz1090/gpio.h>
Date: Tue, 23 Apr 2013 15:33:23 +0100
Message-ID: <1366727607-27444-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_23_15_34_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add <asm/soc-tz1090/gpio.h> with definitions to number all the GPIOs
available on-chip. This is for use by the pinctrl and GPIO drivers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/soc-tz1090/gpio.h | 121 +++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 arch/metag/include/asm/soc-tz1090/gpio.h

diff --git a/arch/metag/include/asm/soc-tz1090/gpio.h b/arch/metag/include/asm/soc-tz1090/gpio.h
new file mode 100644
index 0000000..d19fe02
--- /dev/null
+++ b/arch/metag/include/asm/soc-tz1090/gpio.h
@@ -0,0 +1,121 @@
+#ifndef _TZ1090_GPIO_H_
+#define _TZ1090_GPIO_H_
+
+/* TZ1090 has 90 main GPIOs, in 3 banks of 30. */
+#define NR_BUILTIN_GPIO		90
+/* Plus 7 PDC GPIOs */
+#define NR_PDC_GPIO		7
+
+#define GPIO_0_BASE	0
+#define GPIO_0_PIN(x)	(GPIO_0_BASE + (x))
+
+#define GPIO_1_BASE	30
+#define GPIO_1_PIN(x)	(GPIO_1_BASE + (x))
+
+#define GPIO_2_BASE	60
+#define GPIO_2_PIN(x)	(GPIO_2_BASE + (x))
+
+#define GPIO_PDC_BASE	NR_BUILTIN_GPIO
+#define GPIO_PDC_PIN(x)	(GPIO_PDC_BASE + (x))
+
+#define GPIO_SDIO_CLK		GPIO_0_PIN(0)
+#define GPIO_SDIO_CMD		GPIO_0_PIN(1)
+#define GPIO_SDIO_D0		GPIO_0_PIN(2)
+#define GPIO_SDIO_D1		GPIO_0_PIN(3)
+#define GPIO_SDIO_D2		GPIO_0_PIN(4)
+#define GPIO_SDIO_D3		GPIO_0_PIN(5)
+#define GPIO_SDH_CD		GPIO_0_PIN(6)
+#define GPIO_SDH_WP		GPIO_0_PIN(7)
+#define GPIO_SPI0_MCLK		GPIO_0_PIN(8)
+#define GPIO_SPI0_CS0		GPIO_0_PIN(9)
+#define GPIO_SPI0_CS1		GPIO_0_PIN(10)
+#define GPIO_SPI0_CS2		GPIO_0_PIN(11)
+#define GPIO_SPI0_DOUT		GPIO_0_PIN(12)
+#define GPIO_SPI0_DIN		GPIO_0_PIN(13)
+#define GPIO_SPI1_MCLK		GPIO_0_PIN(14)
+#define GPIO_SPI1_CS0		GPIO_0_PIN(15)
+#define GPIO_SPI1_CS1		GPIO_0_PIN(16)
+#define GPIO_SPI1_CS2		GPIO_0_PIN(17)
+#define GPIO_SPI1_DOUT		GPIO_0_PIN(18)
+#define GPIO_SPI1_DIN		GPIO_0_PIN(19)
+#define GPIO_UART0_RXD		GPIO_0_PIN(20)
+#define GPIO_UART0_TXD		GPIO_0_PIN(21)
+#define GPIO_UART0_CTS		GPIO_0_PIN(22)
+#define GPIO_UART0_RTS		GPIO_0_PIN(23)
+#define GPIO_UART1_RXD		GPIO_0_PIN(24)
+#define GPIO_UART1_TXD		GPIO_0_PIN(25)
+#define GPIO_SCB0_SDAT		GPIO_0_PIN(26)
+#define GPIO_SCB0_SCLK		GPIO_0_PIN(27)
+#define GPIO_SCB1_SDAT		GPIO_0_PIN(28)
+#define GPIO_SCB1_SCLK		GPIO_0_PIN(29)
+#define GPIO_SCB2_SDAT		GPIO_1_PIN(0)
+#define GPIO_SCB2_SCLK		GPIO_1_PIN(1)
+#define GPIO_I2S_MCLK		GPIO_1_PIN(2)
+#define GPIO_I2S_BCLK_OUT	GPIO_1_PIN(3)
+#define GPIO_I2S_LRCLK_OUT	GPIO_1_PIN(4)
+#define GPIO_I2S_DOUT0		GPIO_1_PIN(5)
+#define GPIO_I2S_DOUT1		GPIO_1_PIN(6)
+#define GPIO_I2S_DOUT2		GPIO_1_PIN(7)
+#define GPIO_I2S_DIN		GPIO_1_PIN(8)
+#define GPIO_PDM_A		GPIO_1_PIN(9)
+#define GPIO_PDM_B		GPIO_1_PIN(10)
+#define GPIO_PDM_C		GPIO_1_PIN(11)
+#define GPIO_PDM_D		GPIO_1_PIN(12)
+#define GPIO_TFT_RED0		GPIO_1_PIN(13)
+#define GPIO_TFT_RED1		GPIO_1_PIN(14)
+#define GPIO_TFT_RED2		GPIO_1_PIN(15)
+#define GPIO_TFT_RED3		GPIO_1_PIN(16)
+#define GPIO_TFT_RED4		GPIO_1_PIN(17)
+#define GPIO_TFT_RED5		GPIO_1_PIN(18)
+#define GPIO_TFT_RED6		GPIO_1_PIN(19)
+#define GPIO_TFT_RED7		GPIO_1_PIN(20)
+#define GPIO_TFT_GREEN0		GPIO_1_PIN(21)
+#define GPIO_TFT_GREEN1		GPIO_1_PIN(22)
+#define GPIO_TFT_GREEN2		GPIO_1_PIN(23)
+#define GPIO_TFT_GREEN3		GPIO_1_PIN(24)
+#define GPIO_TFT_GREEN4		GPIO_1_PIN(25)
+#define GPIO_TFT_GREEN5		GPIO_1_PIN(26)
+#define GPIO_TFT_GREEN6		GPIO_1_PIN(27)
+#define GPIO_TFT_GREEN7		GPIO_1_PIN(28)
+#define GPIO_TFT_BLUE0		GPIO_1_PIN(29)
+#define GPIO_TFT_BLUE1		GPIO_2_PIN(0)
+#define GPIO_TFT_BLUE2		GPIO_2_PIN(1)
+#define GPIO_TFT_BLUE3		GPIO_2_PIN(2)
+#define GPIO_TFT_BLUE4		GPIO_2_PIN(3)
+#define GPIO_TFT_BLUE5		GPIO_2_PIN(4)
+#define GPIO_TFT_BLUE6		GPIO_2_PIN(5)
+#define GPIO_TFT_BLUE7		GPIO_2_PIN(6)
+#define GPIO_TFT_VDDEN_GD	GPIO_2_PIN(7)
+#define GPIO_TFT_PANELCLK	GPIO_2_PIN(8)
+#define GPIO_TFT_BLANK_LS	GPIO_2_PIN(9)
+#define GPIO_TFT_VSYNC_NS	GPIO_2_PIN(10)
+#define GPIO_TFT_HSYNC_NR	GPIO_2_PIN(11)
+#define GPIO_TFT_VD12ACB	GPIO_2_PIN(12)
+#define GPIO_TFT_PWRSAVE	GPIO_2_PIN(13)
+#define GPIO_TX_ON		GPIO_2_PIN(14)
+#define GPIO_RX_ON		GPIO_2_PIN(15)
+#define GPIO_PLL_ON		GPIO_2_PIN(16)
+#define GPIO_PA_ON		GPIO_2_PIN(17)
+#define GPIO_RX_HP		GPIO_2_PIN(18)
+#define GPIO_GAIN0		GPIO_2_PIN(19)
+#define GPIO_GAIN1		GPIO_2_PIN(20)
+#define GPIO_GAIN2		GPIO_2_PIN(21)
+#define GPIO_GAIN3		GPIO_2_PIN(22)
+#define GPIO_GAIN4		GPIO_2_PIN(23)
+#define GPIO_GAIN5		GPIO_2_PIN(24)
+#define GPIO_GAIN6		GPIO_2_PIN(25)
+#define GPIO_GAIN7		GPIO_2_PIN(26)
+#define GPIO_ANT_SEL0		GPIO_2_PIN(27)
+#define GPIO_ANT_SEL1		GPIO_2_PIN(28)
+#define GPIO_SDH_CLK_IN		GPIO_2_PIN(29)
+
+/* PDC GPIOs */
+#define GPIO_PDC_GPIO0		GPIO_PDC_PIN(0)
+#define GPIO_PDC_GPIO1		GPIO_PDC_PIN(1)
+#define GPIO_SYS_WAKE0		GPIO_PDC_PIN(2)
+#define GPIO_SYS_WAKE1		GPIO_PDC_PIN(3)
+#define GPIO_SYS_WAKE2		GPIO_PDC_PIN(4)
+#define GPIO_IR_DATA		GPIO_PDC_PIN(5)
+#define GPIO_EXT_POWER		GPIO_PDC_PIN(6)
+
+#endif
-- 
1.8.1.2


