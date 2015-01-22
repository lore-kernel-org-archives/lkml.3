Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbbAVHDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:03:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51179 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbAVHDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73GHB021320, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 1/9] mfd: rtsx: replace TAB by SPC after #define
Date: Thu, 22 Jan 2015 15:03:08 +0800
Message-ID: <48abf73da65a522c3b7123d958866984271e4bd8.1421909642.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421909642.git.micky_ching@realsil.com.cn>
References: <cover.1421909642.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Re-format coding-style, using uniform SPC after "#define" keyword
instead of mixing using TAB and SPC.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 include/linux/mfd/rtsx_pci.h | 254 +++++++++++++++++++++----------------------
 1 file changed, 127 insertions(+), 127 deletions(-)

diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 0c12628..a9c2a14 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -175,9 +175,9 @@
 /* CARD_SHARE_MODE */
 #define CARD_SHARE_MASK			0x0F
 #define CARD_SHARE_MULTI_LUN		0x00
-#define	CARD_SHARE_NORMAL		0x00
-#define	CARD_SHARE_48_SD		0x04
-#define	CARD_SHARE_48_MS		0x08
+#define CARD_SHARE_NORMAL		0x00
+#define CARD_SHARE_48_SD		0x04
+#define CARD_SHARE_48_MS		0x08
 /* CARD_SHARE_MODE for barossa */
 #define CARD_SHARE_BAROSSA_SD		0x01
 #define CARD_SHARE_BAROSSA_MS		0x02
@@ -249,76 +249,76 @@
 #define CD_AUTO_DISABLE			0x40
 
 /* SD_STAT1 */
-#define	SD_CRC7_ERR			0x80
-#define	SD_CRC16_ERR			0x40
-#define	SD_CRC_WRITE_ERR		0x20
-#define	SD_CRC_WRITE_ERR_MASK		0x1C
-#define	GET_CRC_TIME_OUT		0x02
-#define	SD_TUNING_COMPARE_ERR		0x01
+#define SD_CRC7_ERR			0x80
+#define SD_CRC16_ERR			0x40
+#define SD_CRC_WRITE_ERR		0x20
+#define SD_CRC_WRITE_ERR_MASK		0x1C
+#define GET_CRC_TIME_OUT		0x02
+#define SD_TUNING_COMPARE_ERR		0x01
 
 /* SD_STAT2 */
-#define	SD_RSP_80CLK_TIMEOUT		0x01
+#define SD_RSP_80CLK_TIMEOUT		0x01
 
 /* SD_BUS_STAT */
-#define	SD_CLK_TOGGLE_EN		0x80
-#define	SD_CLK_FORCE_STOP	        0x40
-#define	SD_DAT3_STATUS		        0x10
-#define	SD_DAT2_STATUS		        0x08
-#define	SD_DAT1_STATUS		        0x04
-#define	SD_DAT0_STATUS		        0x02
-#define	SD_CMD_STATUS			0x01
+#define SD_CLK_TOGGLE_EN		0x80
+#define SD_CLK_FORCE_STOP	        0x40
+#define SD_DAT3_STATUS		        0x10
+#define SD_DAT2_STATUS		        0x08
+#define SD_DAT1_STATUS		        0x04
+#define SD_DAT0_STATUS		        0x02
+#define SD_CMD_STATUS			0x01
 
 /* SD_PAD_CTL */
-#define	SD_IO_USING_1V8		        0x80
-#define	SD_IO_USING_3V3		        0x7F
-#define	TYPE_A_DRIVING		        0x00
-#define	TYPE_B_DRIVING			0x01
-#define	TYPE_C_DRIVING			0x02
-#define	TYPE_D_DRIVING		        0x03
+#define SD_IO_USING_1V8		        0x80
+#define SD_IO_USING_3V3		        0x7F
+#define TYPE_A_DRIVING		        0x00
+#define TYPE_B_DRIVING			0x01
+#define TYPE_C_DRIVING			0x02
+#define TYPE_D_DRIVING		        0x03
 
 /* SD_SAMPLE_POINT_CTL */
-#define	DDR_FIX_RX_DAT			0x00
-#define	DDR_VAR_RX_DAT			0x80
-#define	DDR_FIX_RX_DAT_EDGE		0x00
-#define	DDR_FIX_RX_DAT_14_DELAY		0x40
-#define	DDR_FIX_RX_CMD			0x00
-#define	DDR_VAR_RX_CMD			0x20
-#define	DDR_FIX_RX_CMD_POS_EDGE		0x00
-#define	DDR_FIX_RX_CMD_14_DELAY		0x10
-#define	SD20_RX_POS_EDGE		0x00
-#define	SD20_RX_14_DELAY		0x08
+#define DDR_FIX_RX_DAT			0x00
+#define DDR_VAR_RX_DAT			0x80
+#define DDR_FIX_RX_DAT_EDGE		0x00
+#define DDR_FIX_RX_DAT_14_DELAY		0x40
+#define DDR_FIX_RX_CMD			0x00
+#define DDR_VAR_RX_CMD			0x20
+#define DDR_FIX_RX_CMD_POS_EDGE		0x00
+#define DDR_FIX_RX_CMD_14_DELAY		0x10
+#define SD20_RX_POS_EDGE		0x00
+#define SD20_RX_14_DELAY		0x08
 #define SD20_RX_SEL_MASK		0x08
 
 /* SD_PUSH_POINT_CTL */
-#define	DDR_FIX_TX_CMD_DAT		0x00
-#define	DDR_VAR_TX_CMD_DAT		0x80
-#define	DDR_FIX_TX_DAT_14_TSU		0x00
-#define	DDR_FIX_TX_DAT_12_TSU		0x40
-#define	DDR_FIX_TX_CMD_NEG_EDGE		0x00
-#define	DDR_FIX_TX_CMD_14_AHEAD		0x20
-#define	SD20_TX_NEG_EDGE		0x00
-#define	SD20_TX_14_AHEAD		0x10
+#define DDR_FIX_TX_CMD_DAT		0x00
+#define DDR_VAR_TX_CMD_DAT		0x80
+#define DDR_FIX_TX_DAT_14_TSU		0x00
+#define DDR_FIX_TX_DAT_12_TSU		0x40
+#define DDR_FIX_TX_CMD_NEG_EDGE		0x00
+#define DDR_FIX_TX_CMD_14_AHEAD		0x20
+#define SD20_TX_NEG_EDGE		0x00
+#define SD20_TX_14_AHEAD		0x10
 #define SD20_TX_SEL_MASK		0x10
-#define	DDR_VAR_SDCLK_POL_SWAP		0x01
+#define DDR_VAR_SDCLK_POL_SWAP		0x01
 
 /* SD_TRANSFER */
-#define	SD_TRANSFER_START		0x80
-#define	SD_TRANSFER_END			0x40
+#define SD_TRANSFER_START		0x80
+#define SD_TRANSFER_END			0x40
 #define SD_STAT_IDLE			0x20
-#define	SD_TRANSFER_ERR			0x10
+#define SD_TRANSFER_ERR			0x10
 /* SD Transfer Mode definition */
-#define	SD_TM_NORMAL_WRITE		0x00
-#define	SD_TM_AUTO_WRITE_3		0x01
-#define	SD_TM_AUTO_WRITE_4		0x02
-#define	SD_TM_AUTO_READ_3		0x05
-#define	SD_TM_AUTO_READ_4		0x06
-#define	SD_TM_CMD_RSP			0x08
-#define	SD_TM_AUTO_WRITE_1		0x09
-#define	SD_TM_AUTO_WRITE_2		0x0A
-#define	SD_TM_NORMAL_READ		0x0C
-#define	SD_TM_AUTO_READ_1		0x0D
-#define	SD_TM_AUTO_READ_2		0x0E
-#define	SD_TM_AUTO_TUNING		0x0F
+#define SD_TM_NORMAL_WRITE		0x00
+#define SD_TM_AUTO_WRITE_3		0x01
+#define SD_TM_AUTO_WRITE_4		0x02
+#define SD_TM_AUTO_READ_3		0x05
+#define SD_TM_AUTO_READ_4		0x06
+#define SD_TM_CMD_RSP			0x08
+#define SD_TM_AUTO_WRITE_1		0x09
+#define SD_TM_AUTO_WRITE_2		0x0A
+#define SD_TM_NORMAL_READ		0x0C
+#define SD_TM_AUTO_READ_1		0x0D
+#define SD_TM_AUTO_READ_2		0x0E
+#define SD_TM_AUTO_TUNING		0x0F
 
 /* SD_VPTX_CTL / SD_VPRX_CTL */
 #define PHASE_CHANGE			0x80
@@ -332,15 +332,15 @@
 
 /* SD Configure 1 Register */
 #define SD_CLK_DIVIDE_0			0x00
-#define	SD_CLK_DIVIDE_256		0xC0
-#define	SD_CLK_DIVIDE_128		0x80
-#define	SD_BUS_WIDTH_1BIT		0x00
-#define	SD_BUS_WIDTH_4BIT		0x01
-#define	SD_BUS_WIDTH_8BIT		0x02
-#define	SD_ASYNC_FIFO_NOT_RST		0x10
-#define	SD_20_MODE			0x00
-#define	SD_DDR_MODE			0x04
-#define	SD_30_MODE			0x08
+#define SD_CLK_DIVIDE_256		0xC0
+#define SD_CLK_DIVIDE_128		0x80
+#define SD_BUS_WIDTH_1BIT		0x00
+#define SD_BUS_WIDTH_4BIT		0x01
+#define SD_BUS_WIDTH_8BIT		0x02
+#define SD_ASYNC_FIFO_NOT_RST		0x10
+#define SD_20_MODE			0x00
+#define SD_DDR_MODE			0x04
+#define SD_30_MODE			0x08
 
 #define SD_CLK_DIVIDE_MASK		0xC0
 
@@ -415,71 +415,71 @@
 #define CLK_DIV_8			0x04
 
 /* MS_CFG */
-#define	SAMPLE_TIME_RISING		0x00
-#define	SAMPLE_TIME_FALLING		0x80
-#define	PUSH_TIME_DEFAULT		0x00
-#define	PUSH_TIME_ODD			0x40
-#define	NO_EXTEND_TOGGLE		0x00
-#define	EXTEND_TOGGLE_CHK		0x20
-#define	MS_BUS_WIDTH_1			0x00
-#define	MS_BUS_WIDTH_4			0x10
-#define	MS_BUS_WIDTH_8			0x18
-#define	MS_2K_SECTOR_MODE		0x04
-#define	MS_512_SECTOR_MODE		0x00
-#define	MS_TOGGLE_TIMEOUT_EN		0x00
-#define	MS_TOGGLE_TIMEOUT_DISEN		0x01
+#define SAMPLE_TIME_RISING		0x00
+#define SAMPLE_TIME_FALLING		0x80
+#define PUSH_TIME_DEFAULT		0x00
+#define PUSH_TIME_ODD			0x40
+#define NO_EXTEND_TOGGLE		0x00
+#define EXTEND_TOGGLE_CHK		0x20
+#define MS_BUS_WIDTH_1			0x00
+#define MS_BUS_WIDTH_4			0x10
+#define MS_BUS_WIDTH_8			0x18
+#define MS_2K_SECTOR_MODE		0x04
+#define MS_512_SECTOR_MODE		0x00
+#define MS_TOGGLE_TIMEOUT_EN		0x00
+#define MS_TOGGLE_TIMEOUT_DISEN		0x01
 #define MS_NO_CHECK_INT			0x02
 
 /* MS_TRANS_CFG */
-#define	WAIT_INT			0x80
-#define	NO_WAIT_INT			0x00
-#define	NO_AUTO_READ_INT_REG		0x00
-#define	AUTO_READ_INT_REG		0x40
-#define	MS_CRC16_ERR			0x20
-#define	MS_RDY_TIMEOUT			0x10
-#define	MS_INT_CMDNK			0x08
-#define	MS_INT_BREQ			0x04
-#define	MS_INT_ERR			0x02
-#define	MS_INT_CED			0x01
+#define WAIT_INT			0x80
+#define NO_WAIT_INT			0x00
+#define NO_AUTO_READ_INT_REG		0x00
+#define AUTO_READ_INT_REG		0x40
+#define MS_CRC16_ERR			0x20
+#define MS_RDY_TIMEOUT			0x10
+#define MS_INT_CMDNK			0x08
+#define MS_INT_BREQ			0x04
+#define MS_INT_ERR			0x02
+#define MS_INT_CED			0x01
 
 /* MS_TRANSFER */
-#define	MS_TRANSFER_START		0x80
-#define	MS_TRANSFER_END			0x40
-#define	MS_TRANSFER_ERR			0x20
-#define	MS_BS_STATE			0x10
-#define	MS_TM_READ_BYTES		0x00
-#define	MS_TM_NORMAL_READ		0x01
-#define	MS_TM_WRITE_BYTES		0x04
-#define	MS_TM_NORMAL_WRITE		0x05
-#define	MS_TM_AUTO_READ			0x08
-#define	MS_TM_AUTO_WRITE		0x0C
+#define MS_TRANSFER_START		0x80
+#define MS_TRANSFER_END			0x40
+#define MS_TRANSFER_ERR			0x20
+#define MS_BS_STATE			0x10
+#define MS_TM_READ_BYTES		0x00
+#define MS_TM_NORMAL_READ		0x01
+#define MS_TM_WRITE_BYTES		0x04
+#define MS_TM_NORMAL_WRITE		0x05
+#define MS_TM_AUTO_READ			0x08
+#define MS_TM_AUTO_WRITE		0x0C
 
 /* SD Configure 2 Register */
-#define	SD_CALCULATE_CRC7		0x00
-#define	SD_NO_CALCULATE_CRC7		0x80
-#define	SD_CHECK_CRC16			0x00
-#define	SD_NO_CHECK_CRC16		0x40
+#define SD_CALCULATE_CRC7		0x00
+#define SD_NO_CALCULATE_CRC7		0x80
+#define SD_CHECK_CRC16			0x00
+#define SD_NO_CHECK_CRC16		0x40
 #define SD_NO_CHECK_WAIT_CRC_TO		0x20
-#define	SD_WAIT_BUSY_END		0x08
-#define	SD_NO_WAIT_BUSY_END		0x00
-#define	SD_CHECK_CRC7			0x00
-#define	SD_NO_CHECK_CRC7		0x04
-#define	SD_RSP_LEN_0			0x00
-#define	SD_RSP_LEN_6			0x01
-#define	SD_RSP_LEN_17			0x02
+#define SD_WAIT_BUSY_END		0x08
+#define SD_NO_WAIT_BUSY_END		0x00
+#define SD_CHECK_CRC7			0x00
+#define SD_NO_CHECK_CRC7		0x04
+#define SD_RSP_LEN_0			0x00
+#define SD_RSP_LEN_6			0x01
+#define SD_RSP_LEN_17			0x02
 /* SD/MMC Response Type Definition */
-#define	SD_RSP_TYPE_R0			0x04
-#define	SD_RSP_TYPE_R1			0x01
-#define	SD_RSP_TYPE_R1b			0x09
-#define	SD_RSP_TYPE_R2			0x02
-#define	SD_RSP_TYPE_R3			0x05
-#define	SD_RSP_TYPE_R4			0x05
-#define	SD_RSP_TYPE_R5			0x01
-#define	SD_RSP_TYPE_R6			0x01
-#define	SD_RSP_TYPE_R7			0x01
+#define SD_RSP_TYPE_R0			0x04
+#define SD_RSP_TYPE_R1			0x01
+#define SD_RSP_TYPE_R1b			0x09
+#define SD_RSP_TYPE_R2			0x02
+#define SD_RSP_TYPE_R3			0x05
+#define SD_RSP_TYPE_R4			0x05
+#define SD_RSP_TYPE_R5			0x01
+#define SD_RSP_TYPE_R6			0x01
+#define SD_RSP_TYPE_R7			0x01
 
 /* SD_CONFIGURE3 */
-#define	SD_RSP_80CLK_TIMEOUT_EN		0x01
+#define SD_RSP_80CLK_TIMEOUT_EN		0x01
 
 /* Card Transfer Reset Register */
 #define SPI_STOP			0x01
@@ -574,13 +574,13 @@
 
 #define SRCTL				0xFC13
 
-#define	DCM_DRP_CTL			0xFC23
-#define	DCM_DRP_TRIG			0xFC24
-#define	DCM_DRP_CFG			0xFC25
-#define	DCM_DRP_WR_DATA_L		0xFC26
-#define	DCM_DRP_WR_DATA_H		0xFC27
-#define	DCM_DRP_RD_DATA_L		0xFC28
-#define	DCM_DRP_RD_DATA_H		0xFC29
+#define DCM_DRP_CTL			0xFC23
+#define DCM_DRP_TRIG			0xFC24
+#define DCM_DRP_CFG			0xFC25
+#define DCM_DRP_WR_DATA_L		0xFC26
+#define DCM_DRP_WR_DATA_H		0xFC27
+#define DCM_DRP_RD_DATA_L		0xFC28
+#define DCM_DRP_RD_DATA_H		0xFC29
 #define SD_VPCLK0_CTL			0xFC2A
 #define SD_VPCLK1_CTL			0xFC2B
 #define SD_DCMPS0_CTL			0xFC2C
-- 
1.9.1

