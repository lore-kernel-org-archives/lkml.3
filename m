Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaABX5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:57:39 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:39141 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:57:37 -0500
Date: Fri, 3 Jan 2014 00:57:02 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8188eu: Fixed spaces before tabs and before
 close parentheses
Message-ID: <20140102235702.GA5658@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all space before tab warnings and space before close parenthesis
errors on rtl8188e_spec.h

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/include/rtl8188e_spec.h | 70 +++++++++++------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_spec.h b/drivers/staging/rtl8188eu/include/rtl8188e_spec.h
index c12c56b9..2c33eb3 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_spec.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_spec.h
@@ -68,7 +68,7 @@
 #define DISABLE_TRXPKT_BUF_ACCESS	0x0
 
 
-/* 	0x0000h ~ 0x00FFh	System Configuration */
+/*	0x0000h ~ 0x00FFh	System Configuration */
 #define REG_SYS_ISO_CTRL		0x0000
 #define REG_SYS_FUNC_EN			0x0002
 #define REG_APS_FSMCO			0x0004
@@ -142,7 +142,7 @@
 
 #define REG_MAC_PHY_CTRL_NORMAL		0x00f8
 
-/* 	0x0100h ~ 0x01FFh	MACTOP General Configuration */
+/*	0x0100h ~ 0x01FFh	MACTOP General Configuration */
 #define REG_CR				0x0100
 #define REG_PBP				0x0104
 #define REG_PKT_BUFF_ACCESS_CTRL	0x0106
@@ -188,7 +188,7 @@
 
 #define REG_LLT_INIT			0x01E0
 
-/* 	0x0200h ~ 0x027Fh	TXDMA Configuration */
+/*	0x0200h ~ 0x027Fh	TXDMA Configuration */
 #define REG_RQPN			0x0200
 #define REG_FIFOPAGE			0x0204
 #define REG_TDECTRL			0x0208
@@ -196,12 +196,12 @@
 #define REG_TXDMA_STATUS		0x0210
 #define REG_RQPN_NPQ			0x0214
 
-/* 	0x0280h ~ 0x02FFh	RXDMA Configuration */
+/*	0x0280h ~ 0x02FFh	RXDMA Configuration */
 #define		REG_RXDMA_AGG_PG_TH	0x0280
 #define	REG_RXPKT_NUM			0x0284
 #define		REG_RXDMA_STATUS	0x0288
 
-/* 	0x0300h ~ 0x03FFh	PCIe */
+/*	0x0300h ~ 0x03FFh	PCIe */
 #define	REG_PCIE_CTRL_REG		0x0300
 #define	REG_INT_MIG			0x0304	/*  Interrupt Migration */
 #define	REG_BCNQ_DESA			0x0308	/*  TX Beacon Descr Address */
@@ -222,7 +222,7 @@
 #define	REG_PCIE_HISR			0x03A0
 
 /*  spec version 11 */
-/* 	0x0400h ~ 0x047Fh	Protocol Configuration */
+/*	0x0400h ~ 0x047Fh	Protocol Configuration */
 #define REG_VOQ_INFORMATION		0x0400
 #define REG_VIQ_INFORMATION		0x0404
 #define REG_BEQ_INFORMATION		0x0408
@@ -276,7 +276,7 @@
 #define REG_TX_RPT_TIME			0x04F0	/*  2 byte */
 #define REG_DUMMY			0x04FC
 
-/* 	0x0500h ~ 0x05FFh	EDCA Configuration */
+/*	0x0500h ~ 0x05FFh	EDCA Configuration */
 #define REG_EDCA_VO_PARAM		0x0500
 #define REG_EDCA_VI_PARAM		0x0504
 #define REG_EDCA_BE_PARAM		0x0508
@@ -294,16 +294,16 @@
 #define REG_DIS_TXREQ_CLR		0x0523
 #define REG_RD_CTRL			0x0524
 /*  Format for offset 540h-542h: */
-/* 	[3:0]:   TBTT prohibit setup in unit of 32us. The time for HW getting
+/*	[3:0]:   TBTT prohibit setup in unit of 32us. The time for HW getting
  *		 beacon content before TBTT. */
-/* 	[7:4]:   Reserved. */
-/* 	[19:8]:  TBTT prohibit hold in unit of 32us. The time for HW holding
+/*	[7:4]:   Reserved. */
+/*	[19:8]:  TBTT prohibit hold in unit of 32us. The time for HW holding
  *		 to send the beacon packet. */
-/* 	[23:20]: Reserved */
+/*	[23:20]: Reserved */
 /*  Description: */
-/* 	              | */
+/*	              | */
 /*      |<--Setup--|--Hold------------>| */
-/* 	--------------|---------------------- */
+/*	--------------|---------------------- */
 /*                 | */
 /*                TBTT */
 /*  Note: We cannot update beacon content to HW or send any AC packets during
@@ -335,7 +335,7 @@
 #define REG_FW_RESET_TSF_CNT_0		0x05FD
 #define REG_FW_BCN_DIS_CNT		0x05FE
 
-/* 	0x0600h ~ 0x07FFh	WMAC Configuration */
+/*	0x0600h ~ 0x07FFh	WMAC Configuration */
 #define REG_APSD_CTRL			0x0600
 #define REG_BWOPMODE			0x0603
 #define REG_TCR				0x0604
@@ -382,7 +382,7 @@
 #define _RXERR_RPT_SEL(type)		((type) << 28)
 
 /*  Note: */
-/* 	The NAV upper value is very important to WiFi 11n 5.2.3 NAV test.
+/*	The NAV upper value is very important to WiFi 11n 5.2.3 NAV test.
  *	The default value is always too small, but the WiFi TestPlan test
  *	by 25,000 microseconds of NAV through sending CTS in the air.
  *	We must update this value greater than 25,000 microseconds to pass
@@ -422,7 +422,7 @@
 #define REG_MACID1			0x0700
 #define REG_BSSID1			0x0708
 
-/* 	0xFE00h ~ 0xFE55h	USB Configuration */
+/*	0xFE00h ~ 0xFE55h	USB Configuration */
 #define REG_USB_INFO			0xFE17
 #define REG_USB_SPECIAL_OPTION		0xFE55
 #define REG_USB_DMA_AGG_TO		0xFE5B
@@ -689,13 +689,13 @@ Current IOREG MAP
 0x0600h ~ 0x07FFh   WMAC Configuration (512 Bytes)
 0x2000h ~ 0x3FFFh   8051 FW Download Region (8196 Bytes)
 */
-/* 		 8192C (TXPAUSE) transmission pause (Offset 0x522, 8 bits) */
+/*		 8192C (TXPAUSE) transmission pause (Offset 0x522, 8 bits) */
 /*  Note: */
-/* 	The bits of stopping AC(VO/VI/BE/BK) queue in datasheet
+/*	The bits of stopping AC(VO/VI/BE/BK) queue in datasheet
  *	RTL8192S/RTL8192C are wrong, */
-/* 	the correct arragement is VO - Bit0, VI - Bit1, BE - Bit2,
+/*	the correct arragement is VO - Bit0, VI - Bit1, BE - Bit2,
  *	and BK - Bit3. */
-/* 	8723 and 88E may be not correct either in the earlier version. */
+/*	8723 and 88E may be not correct either in the earlier version. */
 #define		StopBecon			BIT6
 #define		StopHigh			BIT5
 #define		StopMgt				BIT4
@@ -733,7 +733,7 @@ Current IOREG MAP
 #define	RCR_MXDMA_OFFSET	8
 #define	RCR_FIFO_OFFSET		13
 
-/* 	0xFE00h ~ 0xFE55h	USB Configuration */
+/*	0xFE00h ~ 0xFE55h	USB Configuration */
 #define REG_USB_INFO			0xFE17
 #define REG_USB_SPECIAL_OPTION		0xFE55
 #define REG_USB_DMA_AGG_TO		0xFE5B
@@ -743,7 +743,7 @@ Current IOREG MAP
 #define REG_USB_HRPWM			0xFE58
 #define REG_USB_HCPWM			0xFE57
 /*        8192C Regsiter Bit and Content definition */
-/* 	0x0000h ~ 0x00FFh	System Configuration */
+/*	0x0000h ~ 0x00FFh	System Configuration */
 
 /* 2 SYS_ISO_CTRL */
 #define ISO_MD2PP			BIT(0)
@@ -914,7 +914,7 @@ Current IOREG MAP
 /* 2SYS_CFG */
 #define RTL_ID				BIT(23)	/*  TestChip ID, 1:Test(RLE); 0:MP(RL) */
 
-/* 	0x0100h ~ 0x01FFh	MACTOP General Configuration */
+/*	0x0100h ~ 0x01FFh	MACTOP General Configuration */
 
 /* 2 Function Enable Registers */
 /* 2 CR */
@@ -975,9 +975,9 @@ Current IOREG MAP
 #define _TXDMA_HIQ_MAP(x)		(((x)&0x3) << 14)
 #define _TXDMA_MGQ_MAP(x)		(((x)&0x3) << 12)
 #define _TXDMA_BKQ_MAP(x)		(((x)&0x3) << 10)
-#define _TXDMA_BEQ_MAP(x)		(((x)&0x3) << 8 )
-#define _TXDMA_VIQ_MAP(x)		(((x)&0x3) << 6 )
-#define _TXDMA_VOQ_MAP(x)		(((x)&0x3) << 4 )
+#define _TXDMA_BEQ_MAP(x)		(((x)&0x3) << 8)
+#define _TXDMA_VIQ_MAP(x)		(((x)&0x3) << 6)
+#define _TXDMA_VOQ_MAP(x)		(((x)&0x3) << 4)
 
 #define QUEUE_LOW			1
 #define QUEUE_NORMAL			2
@@ -995,7 +995,7 @@ Current IOREG MAP
 #define _LLT_OP(x)			(((x) & 0x3) << 30)
 #define _LLT_OP_VALUE(x)		(((x) >> 30) & 0x3)
 
-/* 	0x0200h ~ 0x027Fh	TXDMA Configuration */
+/*	0x0200h ~ 0x027Fh	TXDMA Configuration */
 /* 2RQPN */
 #define _HPQ(x)				((x) & 0xFF)
 #define _LPQ(x)				(((x) & 0xFF) << 8)
@@ -1019,7 +1019,7 @@ Current IOREG MAP
 /* 2 TXDMA_OFFSET_CHK */
 #define DROP_DATA_EN			BIT(9)
 
-/* 	0x0280h ~ 0x028Bh	RX DMA Configuration */
+/*	0x0280h ~ 0x028Bh	RX DMA Configuration */
 
 /*     REG_RXDMA_CONTROL, 0x0286h */
 
@@ -1028,7 +1028,7 @@ Current IOREG MAP
 #define	RXDMA_IDLE			BIT(17)
 #define	RW_RELEASE_EN			BIT(18)
 
-/* 	0x0400h ~ 0x047Fh	Protocol Configuration */
+/*	0x0400h ~ 0x047Fh	Protocol Configuration */
 /* 2 FWHW_TXQ_CTRL */
 #define EN_AMPDU_RTY_NEW		BIT(7)
 
@@ -1040,7 +1040,7 @@ Current IOREG MAP
 #define	RETRY_LIMIT_SHORT_SHIFT		8
 #define	RETRY_LIMIT_LONG_SHIFT		0
 
-/* 	0x0500h ~ 0x05FFh	EDCA Configuration */
+/*	0x0500h ~ 0x05FFh	EDCA Configuration */
 
 /* 2 EDCA setting */
 #define AC_PARAM_TXOP_LIMIT_OFFSET	16
@@ -1071,7 +1071,7 @@ Current IOREG MAP
 #define	AcmHw_ViqStatus		BIT(5)
 #define	AcmHw_VoqStatus		BIT(6)
 
-/* 	0x0600h ~ 0x07FFh	WMAC Configuration */
+/*	0x0600h ~ 0x07FFh	WMAC Configuration */
 /* 2APSD_CTRL */
 #define APSDOFF			BIT(6)
 #define APSDOFF_STATUS		BIT(7)
@@ -1128,7 +1128,7 @@ Current IOREG MAP
 #define SCR_TXBCUSEDK		BIT(6)	/* Force Tx Bcast pkt Use Default Key */
 #define SCR_RXBCUSEDK		BIT(7)	/* Force Rx Bcast pkt Use Default Key */
 
-/* 	RTL8188E SDIO Configuration */
+/*	RTL8188E SDIO Configuration */
 
 /*  I/O bus domain address mapping */
 #define SDIO_LOCAL_BASE			0x10250000
@@ -1264,7 +1264,7 @@ Current IOREG MAP
 #define SDIO_TX_FREE_PG_QUEUE			4
 #define SDIO_TX_FIFO_PAGE_SZ			128
 
-/* 	0xFE00h ~ 0xFE55h	USB Configuration */
+/*	0xFE00h ~ 0xFE55h	USB Configuration */
 
 /* 2 USB Information (0xFE17) */
 #define USB_IS_HIGH_SPEED			0
@@ -1331,7 +1331,7 @@ Current IOREG MAP
 
 /*	8192C EEPROM/EFUSE share register definition. */
 
-/* 	EEPROM/Efuse PG Offset for 88EE/88EU/88ES */
+/*	EEPROM/Efuse PG Offset for 88EE/88EU/88ES */
 #define	EEPROM_TX_PWR_INX_88E			0x10
 
 #define	EEPROM_ChannelPlan_88E			0xB8
@@ -1362,7 +1362,7 @@ Current IOREG MAP
 /*  RTL88ES */
 #define	EEPROM_MAC_ADDR_88ES			0x11A
 
-/* 		EEPROM/Efuse Value Type */
+/*		EEPROM/Efuse Value Type */
 #define EETYPE_TX_PWR				0x0
 
 /*  Default Value for EEPROM or EFUSE!!! */
-- 
1.8.5.2

