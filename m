Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaEOJgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:36:36 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64932 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaEOJgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:36:32 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 02/14] mmc: mmci: convert register bits to use BIT() macro.
Date: Thu, 15 May 2014 10:36:28 +0100
Message-Id: <1400146588-29888-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch converts the register bits in the header file to use BIT(()
macro, which looks much neater.

No functional changes done.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.h | 208 ++++++++++++++++++++++++------------------------
 1 file changed, 104 insertions(+), 104 deletions(-)

diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 347d942..cd83ca3 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -11,48 +11,48 @@
 #define MCI_PWR_OFF		0x00
 #define MCI_PWR_UP		0x02
 #define MCI_PWR_ON		0x03
-#define MCI_OD			(1 << 6)
-#define MCI_ROD			(1 << 7)
+#define MCI_OD			BIT(6)
+#define MCI_ROD			BIT(7)
 /*
  * The ST Micro version does not have ROD and reuse the voltage registers for
  * direction settings.
  */
-#define MCI_ST_DATA2DIREN	(1 << 2)
-#define MCI_ST_CMDDIREN		(1 << 3)
-#define MCI_ST_DATA0DIREN	(1 << 4)
-#define MCI_ST_DATA31DIREN	(1 << 5)
-#define MCI_ST_FBCLKEN		(1 << 7)
-#define MCI_ST_DATA74DIREN	(1 << 8)
+#define MCI_ST_DATA2DIREN	BIT(2)
+#define MCI_ST_CMDDIREN		BIT(3)
+#define MCI_ST_DATA0DIREN	BIT(4)
+#define MCI_ST_DATA31DIREN	BIT(5)
+#define MCI_ST_FBCLKEN		BIT(7)
+#define MCI_ST_DATA74DIREN	BIT(8)
 
 #define MMCICLOCK		0x004
-#define MCI_CLK_ENABLE		(1 << 8)
-#define MCI_CLK_PWRSAVE		(1 << 9)
-#define MCI_CLK_BYPASS		(1 << 10)
-#define MCI_4BIT_BUS		(1 << 11)
+#define MCI_CLK_ENABLE		BIT(8)
+#define MCI_CLK_PWRSAVE		BIT(9)
+#define MCI_CLK_BYPASS		BIT(10)
+#define MCI_4BIT_BUS		BIT(11)
 /*
  * 8bit wide buses, hardware flow contronl, negative edges and clock inversion
  * supported in ST Micro U300 and Ux500 versions
  */
-#define MCI_ST_8BIT_BUS		(1 << 12)
-#define MCI_ST_U300_HWFCEN	(1 << 13)
-#define MCI_ST_UX500_NEG_EDGE	(1 << 13)
-#define MCI_ST_UX500_HWFCEN	(1 << 14)
-#define MCI_ST_UX500_CLK_INV	(1 << 15)
+#define MCI_ST_8BIT_BUS		BIT(12)
+#define MCI_ST_U300_HWFCEN	BIT(13)
+#define MCI_ST_UX500_NEG_EDGE	BIT(13)
+#define MCI_ST_UX500_HWFCEN	BIT(14)
+#define MCI_ST_UX500_CLK_INV	BIT(15)
 /* Modified PL180 on Versatile Express platform */
-#define MCI_ARM_HWFCEN		(1 << 12)
+#define MCI_ARM_HWFCEN		BIT(12)
 
 #define MMCIARGUMENT		0x008
 #define MMCICOMMAND		0x00c
-#define MCI_CPSM_RESPONSE	(1 << 6)
-#define MCI_CPSM_LONGRSP	(1 << 7)
-#define MCI_CPSM_INTERRUPT	(1 << 8)
-#define MCI_CPSM_PENDING	(1 << 9)
-#define MCI_CPSM_ENABLE		(1 << 10)
+#define MCI_CPSM_RESPONSE	BIT(6)
+#define MCI_CPSM_LONGRSP	BIT(7)
+#define MCI_CPSM_INTERRUPT	BIT(8)
+#define MCI_CPSM_PENDING	BIT(9)
+#define MCI_CPSM_ENABLE		BIT(10)
 /* Argument flag extenstions in the ST Micro versions */
-#define MCI_ST_SDIO_SUSP	(1 << 11)
-#define MCI_ST_ENCMD_COMPL	(1 << 12)
-#define MCI_ST_NIEN		(1 << 13)
-#define MCI_ST_CE_ATACMD	(1 << 14)
+#define MCI_ST_SDIO_SUSP	BIT(11)
+#define MCI_ST_ENCMD_COMPL	BIT(12)
+#define MCI_ST_NIEN		BIT(13)
+#define MCI_ST_CE_ATACMD	BIT(14)
 
 #define MMCIRESPCMD		0x010
 #define MMCIRESPONSE0		0x014
@@ -62,95 +62,95 @@
 #define MMCIDATATIMER		0x024
 #define MMCIDATALENGTH		0x028
 #define MMCIDATACTRL		0x02c
-#define MCI_DPSM_ENABLE		(1 << 0)
-#define MCI_DPSM_DIRECTION	(1 << 1)
-#define MCI_DPSM_MODE		(1 << 2)
-#define MCI_DPSM_DMAENABLE	(1 << 3)
-#define MCI_DPSM_BLOCKSIZE	(1 << 4)
+#define MCI_DPSM_ENABLE		BIT(0)
+#define MCI_DPSM_DIRECTION	BIT(1)
+#define MCI_DPSM_MODE		BIT(2)
+#define MCI_DPSM_DMAENABLE	BIT(3)
+#define MCI_DPSM_BLOCKSIZE	BIT(4)
 /* Control register extensions in the ST Micro U300 and Ux500 versions */
-#define MCI_ST_DPSM_RWSTART	(1 << 8)
-#define MCI_ST_DPSM_RWSTOP	(1 << 9)
-#define MCI_ST_DPSM_RWMOD	(1 << 10)
-#define MCI_ST_DPSM_SDIOEN	(1 << 11)
+#define MCI_ST_DPSM_RWSTART	BIT(8)
+#define MCI_ST_DPSM_RWSTOP	BIT(9)
+#define MCI_ST_DPSM_RWMOD	BIT(10)
+#define MCI_ST_DPSM_SDIOEN	BIT(11)
 /* Control register extensions in the ST Micro Ux500 versions */
-#define MCI_ST_DPSM_DMAREQCTL	(1 << 12)
-#define MCI_ST_DPSM_DBOOTMODEEN	(1 << 13)
-#define MCI_ST_DPSM_BUSYMODE	(1 << 14)
-#define MCI_ST_DPSM_DDRMODE	(1 << 15)
+#define MCI_ST_DPSM_DMAREQCTL	BIT(12)
+#define MCI_ST_DPSM_DBOOTMODEEN	BIT(13)
+#define MCI_ST_DPSM_BUSYMODE	BIT(14)
+#define MCI_ST_DPSM_DDRMODE	BIT(15)
 
 #define MMCIDATACNT		0x030
 #define MMCISTATUS		0x034
-#define MCI_CMDCRCFAIL		(1 << 0)
-#define MCI_DATACRCFAIL		(1 << 1)
-#define MCI_CMDTIMEOUT		(1 << 2)
-#define MCI_DATATIMEOUT		(1 << 3)
-#define MCI_TXUNDERRUN		(1 << 4)
-#define MCI_RXOVERRUN		(1 << 5)
-#define MCI_CMDRESPEND		(1 << 6)
-#define MCI_CMDSENT		(1 << 7)
-#define MCI_DATAEND		(1 << 8)
-#define MCI_STARTBITERR		(1 << 9)
-#define MCI_DATABLOCKEND	(1 << 10)
-#define MCI_CMDACTIVE		(1 << 11)
-#define MCI_TXACTIVE		(1 << 12)
-#define MCI_RXACTIVE		(1 << 13)
-#define MCI_TXFIFOHALFEMPTY	(1 << 14)
-#define MCI_RXFIFOHALFFULL	(1 << 15)
-#define MCI_TXFIFOFULL		(1 << 16)
-#define MCI_RXFIFOFULL		(1 << 17)
-#define MCI_TXFIFOEMPTY		(1 << 18)
-#define MCI_RXFIFOEMPTY		(1 << 19)
-#define MCI_TXDATAAVLBL		(1 << 20)
-#define MCI_RXDATAAVLBL		(1 << 21)
+#define MCI_CMDCRCFAIL		BIT(0)
+#define MCI_DATACRCFAIL		BIT(1)
+#define MCI_CMDTIMEOUT		BIT(2)
+#define MCI_DATATIMEOUT		BIT(3)
+#define MCI_TXUNDERRUN		BIT(4)
+#define MCI_RXOVERRUN		BIT(5)
+#define MCI_CMDRESPEND		BIT(6)
+#define MCI_CMDSENT		BIT(7)
+#define MCI_DATAEND		BIT(8)
+#define MCI_STARTBITERR		BIT(9)
+#define MCI_DATABLOCKEND	BIT(10)
+#define MCI_CMDACTIVE		BIT(11)
+#define MCI_TXACTIVE		BIT(12)
+#define MCI_RXACTIVE		BIT(13)
+#define MCI_TXFIFOHALFEMPTY	BIT(14)
+#define MCI_RXFIFOHALFFULL	BIT(15)
+#define MCI_TXFIFOFULL		BIT(16)
+#define MCI_RXFIFOFULL		BIT(17)
+#define MCI_TXFIFOEMPTY		BIT(18)
+#define MCI_RXFIFOEMPTY		BIT(19)
+#define MCI_TXDATAAVLBL		BIT(20)
+#define MCI_RXDATAAVLBL		BIT(21)
 /* Extended status bits for the ST Micro variants */
-#define MCI_ST_SDIOIT		(1 << 22)
-#define MCI_ST_CEATAEND		(1 << 23)
-#define MCI_ST_CARDBUSY		(1 << 24)
+#define MCI_ST_SDIOIT		BIT(22)
+#define MCI_ST_CEATAEND		BIT(23)
+#define MCI_ST_CARDBUSY		BIT(24)
 
 #define MMCICLEAR		0x038
-#define MCI_CMDCRCFAILCLR	(1 << 0)
-#define MCI_DATACRCFAILCLR	(1 << 1)
-#define MCI_CMDTIMEOUTCLR	(1 << 2)
-#define MCI_DATATIMEOUTCLR	(1 << 3)
-#define MCI_TXUNDERRUNCLR	(1 << 4)
-#define MCI_RXOVERRUNCLR	(1 << 5)
-#define MCI_CMDRESPENDCLR	(1 << 6)
-#define MCI_CMDSENTCLR		(1 << 7)
-#define MCI_DATAENDCLR		(1 << 8)
-#define MCI_STARTBITERRCLR	(1 << 9)
-#define MCI_DATABLOCKENDCLR	(1 << 10)
+#define MCI_CMDCRCFAILCLR	BIT(0)
+#define MCI_DATACRCFAILCLR	BIT(1)
+#define MCI_CMDTIMEOUTCLR	BIT(2)
+#define MCI_DATATIMEOUTCLR	BIT(3)
+#define MCI_TXUNDERRUNCLR	BIT(4)
+#define MCI_RXOVERRUNCLR	BIT(5)
+#define MCI_CMDRESPENDCLR	BIT(6)
+#define MCI_CMDSENTCLR		BIT(7)
+#define MCI_DATAENDCLR		BIT(8)
+#define MCI_STARTBITERRCLR	BIT(9)
+#define MCI_DATABLOCKENDCLR	BIT(10)
 /* Extended status bits for the ST Micro variants */
-#define MCI_ST_SDIOITC		(1 << 22)
-#define MCI_ST_CEATAENDC	(1 << 23)
-#define MCI_ST_BUSYENDC		(1 << 24)
+#define MCI_ST_SDIOITC		BIT(22)
+#define MCI_ST_CEATAENDC	BIT(23)
+#define MCI_ST_BUSYENDC		BIT(24)
 
 #define MMCIMASK0		0x03c
-#define MCI_CMDCRCFAILMASK	(1 << 0)
-#define MCI_DATACRCFAILMASK	(1 << 1)
-#define MCI_CMDTIMEOUTMASK	(1 << 2)
-#define MCI_DATATIMEOUTMASK	(1 << 3)
-#define MCI_TXUNDERRUNMASK	(1 << 4)
-#define MCI_RXOVERRUNMASK	(1 << 5)
-#define MCI_CMDRESPENDMASK	(1 << 6)
-#define MCI_CMDSENTMASK		(1 << 7)
-#define MCI_DATAENDMASK		(1 << 8)
-#define MCI_STARTBITERRMASK	(1 << 9)
-#define MCI_DATABLOCKENDMASK	(1 << 10)
-#define MCI_CMDACTIVEMASK	(1 << 11)
-#define MCI_TXACTIVEMASK	(1 << 12)
-#define MCI_RXACTIVEMASK	(1 << 13)
-#define MCI_TXFIFOHALFEMPTYMASK	(1 << 14)
-#define MCI_RXFIFOHALFFULLMASK	(1 << 15)
-#define MCI_TXFIFOFULLMASK	(1 << 16)
-#define MCI_RXFIFOFULLMASK	(1 << 17)
-#define MCI_TXFIFOEMPTYMASK	(1 << 18)
-#define MCI_RXFIFOEMPTYMASK	(1 << 19)
-#define MCI_TXDATAAVLBLMASK	(1 << 20)
-#define MCI_RXDATAAVLBLMASK	(1 << 21)
+#define MCI_CMDCRCFAILMASK	BIT(0)
+#define MCI_DATACRCFAILMASK	BIT(1)
+#define MCI_CMDTIMEOUTMASK	BIT(2)
+#define MCI_DATATIMEOUTMASK	BIT(3)
+#define MCI_TXUNDERRUNMASK	BIT(4)
+#define MCI_RXOVERRUNMASK	BIT(5)
+#define MCI_CMDRESPENDMASK	BIT(6)
+#define MCI_CMDSENTMASK		BIT(7)
+#define MCI_DATAENDMASK		BIT(8)
+#define MCI_STARTBITERRMASK	BIT(9)
+#define MCI_DATABLOCKENDMASK	BIT(10)
+#define MCI_CMDACTIVEMASK	BIT(11)
+#define MCI_TXACTIVEMASK	BIT(12)
+#define MCI_RXACTIVEMASK	BIT(13)
+#define MCI_TXFIFOHALFEMPTYMASK	BIT(14)
+#define MCI_RXFIFOHALFFULLMASK	BIT(15)
+#define MCI_TXFIFOFULLMASK	BIT(16)
+#define MCI_RXFIFOFULLMASK	BIT(17)
+#define MCI_TXFIFOEMPTYMASK	BIT(18)
+#define MCI_RXFIFOEMPTYMASK	BIT(19)
+#define MCI_TXDATAAVLBLMASK	BIT(20)
+#define MCI_RXDATAAVLBLMASK	BIT(21)
 /* Extended status bits for the ST Micro variants */
-#define MCI_ST_SDIOITMASK	(1 << 22)
-#define MCI_ST_CEATAENDMASK	(1 << 23)
-#define MCI_ST_BUSYEND		(1 << 24)
+#define MCI_ST_SDIOITMASK	BIT(22)
+#define MCI_ST_CEATAENDMASK	BIT(23)
+#define MCI_ST_BUSYEND		BIT(24)
 
 #define MMCIMASK1		0x040
 #define MMCIFIFOCNT		0x048
-- 
1.9.1

