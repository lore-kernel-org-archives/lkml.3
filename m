Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbbAOQcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:32:25 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:35336 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbbAOQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:32:17 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:36 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Staging: vt6655: comment headings formatting
Date: Fri, 16 Jan 2015 03:29:26 +1100
Message-Id: <1421339367-23521-7-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
References: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the formatting of the comments in mac.h more
consistent.

* Where a heading takes up three comment lines it is reduced to one.
* A newline always separates column headings

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6655/mac.h | 93 +++++++-------------------------------------
 1 file changed, 15 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index d1a56cb..9be9bf8 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -38,9 +38,7 @@
 #include "upc.h"
 
 /*---------------------  Export Definitions -------------------------*/
-//
 // Registers in the MAC
-//
 #define MAC_MAX_CONTEXT_SIZE_PAGE0  256
 #define MAC_MAX_CONTEXT_SIZE_PAGE1  128
 
@@ -69,6 +67,7 @@
 #define MAC_REG_TMCTL0      0x18
 #define MAC_REG_TMCTL1      0x19
 #define MAC_REG_TMDATA0     0x1C
+
 // MAC Parameter related
 #define MAC_REG_LRT         0x20
 #define MAC_REG_SRT         0x21
@@ -85,11 +84,13 @@
 #define MAC_REG_RTSFAILCNT  0x2D
 #define MAC_REG_ACKFAILCNT  0x2E
 #define MAC_REG_FCSERRCNT   0x2F
+
 // TSF Related
 #define MAC_REG_TSFCNTR     0x30
 #define MAC_REG_NEXTTBTT    0x38
 #define MAC_REG_TSFOFST     0x40
 #define MAC_REG_TFTCTL      0x48
+
 // WMAC Control/Status Related
 #define MAC_REG_ENCFG       0x4C
 #define MAC_REG_PAGE1SEL    0x4F
@@ -101,6 +102,7 @@
 #define MAC_REG_TCR         0x57
 #define MAC_REG_IMR         0x58
 #define MAC_REG_ISR         0x5C
+
 // Power Saving Related
 #define MAC_REG_PSCFG       0x60
 #define MAC_REG_PSCTL       0x61
@@ -112,6 +114,7 @@
 #define MAC_REG_CALTMR      0x69
 #define MAC_REG_SYNSPACCNT  0x6A
 #define MAC_REG_WAKSYNOPT   0x6B
+
 // Baseband/IF Control Group
 #define MAC_REG_BBREGCTL    0x6C
 #define MAC_REG_CHANNEL     0x6D
@@ -140,12 +143,15 @@
 #define MAC_REG_SYNCDMAPTR  0xA8
 #define MAC_REG_ATIMDMACTL  0xAC
 #define MAC_REG_ATIMDMAPTR  0xB0
+
 // MiscFF PIO related
 #define MAC_REG_MISCFFNDEX  0xB4
 #define MAC_REG_MISCFFCTL   0xB6
 #define MAC_REG_MISCFFDATA  0xB8
+
 // Extend SW Timer
 #define MAC_REG_TMDATA1     0xBC
+
 // WOW Related Group
 #define MAC_REG_WAKEUPEN0   0xC0
 #define MAC_REG_WAKEUPEN1   0xC1
@@ -161,6 +167,7 @@
 #define MAC_REG_CRC_128_1   0x06
 #define MAC_REG_CRC_128_2   0x08
 #define MAC_REG_CRC_128_3   0x0A
+
 // MAC Configuration Group
 #define MAC_REG_PAR0        0x0C
 #define MAC_REG_PAR4        0x10
@@ -168,6 +175,7 @@
 #define MAC_REG_BSSID4      0x18
 #define MAC_REG_MAR0        0x1C
 #define MAC_REG_MAR4        0x20
+
 // MAC RSPPKT INFO Group
 #define MAC_REG_RSPINF_B_1  0x24
 #define MAC_REG_RSPINF_B_2  0x28
@@ -195,9 +203,7 @@
 #define MAC_REG_PWRCCK      0x73
 #define MAC_REG_PWROFDM     0x7C
 
-//
 // Bits in the BCFG0 register
-//
 #define BCFG0_PERROFF       0x40
 #define BCFG0_MRDMDIS       0x20
 #define BCFG0_MRDLDIS       0x10
@@ -205,9 +211,7 @@
 #define BCFG0_VSERREN       0x02
 #define BCFG0_LATMEN        0x01
 
-//
 // Bits in the BCFG1 register
-//
 #define BCFG1_CFUNOPT       0x80
 #define BCFG1_CREQOPT       0x40
 #define BCFG1_DMA8          0x10
@@ -232,9 +236,7 @@
 #define BISTSR2_CMDPRTEN    0x02
 #define BISTSR2_RAMTSTEN    0x01
 
-//
 // Bits in the I2MCFG EEPROM register
-//
 #define I2MCFG_BOUNDCTL     0x80
 #define I2MCFG_WAITCTL      0x20
 #define I2MCFG_SCLOECTL     0x10
@@ -243,38 +245,28 @@
 #define I2MCFG_I2MLDSEQ     0x02
 #define I2MCFG_I2CMFAST     0x01
 
-//
 // Bits in the I2MCSR EEPROM register
-//
 #define I2MCSR_EEMW         0x80
 #define I2MCSR_EEMR         0x40
 #define I2MCSR_AUTOLD       0x08
 #define I2MCSR_NACK         0x02
 #define I2MCSR_DONE         0x01
 
-//
 // Bits in the PMC1 register
-//
 #define SPS_RST             0x80
 #define PCISTIKY            0x40
 #define PME_OVR             0x02
 
-//
 // Bits in the STICKYHW register
-//
 #define STICKHW_DS1_SHADOW  0x02
 #define STICKHW_DS0_SHADOW  0x01
 
-//
 // Bits in the TMCTL register
-//
 #define TMCTL_TSUSP         0x04
 #define TMCTL_TMD           0x02
 #define TMCTL_TE            0x01
 
-//
 // Bits in the TFTCTL register
-//
 #define TFTCTL_HWUTSF       0x80
 #define TFTCTL_TBTTSYNC     0x40
 #define TFTCTL_HWUTSFEN     0x20
@@ -284,9 +276,7 @@
 #define TFTCTL_TSFCNTRST    0x02
 #define TFTCTL_TSFCNTREN    0x01
 
-//
 // Bits in the EnhanceCFG register
-//
 #define EnCFG_BarkerPream   0x00020000
 #define EnCFG_NXTBTTCFPSTR  0x00010000
 #define EnCFG_BcnSusClr     0x00000200
@@ -300,14 +290,10 @@
 #define EnCFG_BBType_b      0x00000001
 #define EnCFG_BBType_a      0x00000000
 
-//
 // Bits in the Page1Sel register
-//
 #define PAGE1_SEL           0x01
 
-//
 // Bits in the CFG register
-//
 #define CFG_TKIPOPT         0x80
 #define CFG_RXDMAOPT        0x40
 #define CFG_TMOT_SW         0x20
@@ -318,9 +304,7 @@
 #define CFG_NOTXTIMEOUT     0x02
 #define CFG_NOBUFOPT        0x01
 
-//
 // Bits in the TEST register
-//
 #define TEST_LBEXT          0x80
 #define TEST_LBINT          0x40
 #define TEST_LBNONE         0x00
@@ -331,9 +315,7 @@
 #define TEST_NOCTS          0x02
 #define TEST_NOACK          0x01
 
-//
 // Bits in the HOSTCR register
-//
 #define HOSTCR_TXONST       0x80
 #define HOSTCR_RXONST       0x40
 #define HOSTCR_ADHOC        0x20 /* Network Type 1 = Ad-hoc */
@@ -343,21 +325,17 @@
 #define HOSTCR_MACEN        0x02 /* 0000 0010 */
 #define HOSTCR_SOFTRST      0x01 /* 0000 0001 */
 
-//
 // Bits in the MACCR register
-//
 #define MACCR_SYNCFLUSHOK   0x04
 #define MACCR_SYNCFLUSH     0x02
 #define MACCR_CLRNAV        0x01
 
 // Bits in the MAC_REG_GPIOCTL0 register
-//
 #define LED_ACTSET           0x01
 #define LED_RFOFF            0x02
 #define LED_NOCONNECT        0x04
-//
+
 // Bits in the RCR register
-//
 #define RCR_SSID            0x80
 #define RCR_RXALLTYPE       0x40
 #define RCR_UNICAST         0x20
@@ -367,15 +345,11 @@
 #define RCR_ERRCRC          0x02
 #define RCR_BSSID           0x01
 
-//
 // Bits in the TCR register
-//
 #define TCR_SYNCDCFOPT      0x02
 #define TCR_AUTOBCNTX       0x01 /* Beacon automatically transmit enable */
 
-//
 // Bits in the IMR register
-//
 #define IMR_MEASURESTART    0x80000000
 #define IMR_QUIETSTART      0x20000000
 #define IMR_RADARDETECT     0x10000000
@@ -395,10 +369,7 @@
 #define IMR_AC0DMA          0x00000002
 #define IMR_TXDMA0          0x00000001
 
-//
 // Bits in the ISR register
-//
-
 #define ISR_MEASURESTART    0x80000000
 #define ISR_QUIETSTART      0x20000000
 #define ISR_RADARDETECT     0x10000000
@@ -418,9 +389,7 @@
 #define ISR_AC0DMA          0x00000002
 #define ISR_TXDMA0          0x00000001
 
-//
 // Bits in the PSCFG register
-//
 #define PSCFG_PHILIPMD      0x40
 #define PSCFG_WAKECALEN     0x20
 #define PSCFG_WAKETMREN     0x10
@@ -429,9 +398,7 @@
 #define PSCFG_SLEEPSYN      0x02
 #define PSCFG_AUTOSLEEP     0x01
 
-//
 // Bits in the PSCTL register
-//
 #define PSCTL_WAKEDONE      0x20
 #define PSCTL_PS            0x10
 #define PSCTL_GO2DOZE       0x08
@@ -439,9 +406,7 @@
 #define PSCTL_ALBCN         0x02
 #define PSCTL_PSEN          0x01
 
-//
 // Bits in the PSPWSIG register
-//
 #define PSSIG_WPE3          0x80
 #define PSSIG_WPE2          0x40
 #define PSSIG_WPE1          0x20
@@ -451,23 +416,17 @@
 #define PSSIG_SPE1          0x02
 #define PSSIG_SRADIOPE      0x01
 
-//
 // Bits in the BBREGCTL register
-//
 #define BBREGCTL_DONE       0x04
 #define BBREGCTL_REGR       0x02
 #define BBREGCTL_REGW       0x01
 
-//
 // Bits in the IFREGCTL register
-//
 #define IFREGCTL_DONE       0x04
 #define IFREGCTL_IFRF       0x02
 #define IFREGCTL_REGW       0x01
 
-//
 // Bits in the SOFTPWRCTL register
-//
 #define SOFTPWRCTL_RFLEOPT      0x0800
 #define SOFTPWRCTL_TXPEINV      0x0200
 #define SOFTPWRCTL_SWPECTI      0x0100
@@ -478,82 +437,63 @@
 #define SOFTPWRCTL_SWPE1        0x0002
 #define SOFTPWRCTL_SWPE3        0x0001
 
-//
 // Bits in the GPIOCTL1 register
-//
 #define GPIO1_DATA1             0x20
 #define GPIO1_MD1               0x10
 #define GPIO1_DATA0             0x02
 #define GPIO1_MD0               0x01
 
-//
 // Bits in the DMACTL register
-//
 #define DMACTL_CLRRUN       0x00080000
 #define DMACTL_RUN          0x00000008
 #define DMACTL_WAKE         0x00000004
 #define DMACTL_DEAD         0x00000002
 #define DMACTL_ACTIVE       0x00000001
-//
+
 // Bits in the RXDMACTL0 register
-//
 #define RX_PERPKT           0x00000100
 #define RX_PERPKTCLR        0x01000000
-//
+
 // Bits in the BCNDMACTL register
-//
 #define BEACON_READY        0x01
-//
+
 // Bits in the MISCFFCTL register
-//
 #define MISCFFCTL_WRITE     0x0001
 
-//
 // Bits in WAKEUPEN0
-//
 #define WAKEUPEN0_DIRPKT    0x10
 #define WAKEUPEN0_LINKOFF   0x08
 #define WAKEUPEN0_ATIMEN    0x04
 #define WAKEUPEN0_TIMEN     0x02
 #define WAKEUPEN0_MAGICEN   0x01
 
-//
 // Bits in WAKEUPEN1
-//
 #define WAKEUPEN1_128_3     0x08
 #define WAKEUPEN1_128_2     0x04
 #define WAKEUPEN1_128_1     0x02
 #define WAKEUPEN1_128_0     0x01
 
-//
 // Bits in WAKEUPSR0
-//
 #define WAKEUPSR0_DIRPKT    0x10
 #define WAKEUPSR0_LINKOFF   0x08
 #define WAKEUPSR0_ATIMEN    0x04
 #define WAKEUPSR0_TIMEN     0x02
 #define WAKEUPSR0_MAGICEN   0x01
 
-//
 // Bits in WAKEUPSR1
-//
 #define WAKEUPSR1_128_3     0x08
 #define WAKEUPSR1_128_2     0x04
 #define WAKEUPSR1_128_1     0x02
 #define WAKEUPSR1_128_0     0x01
 
-//
 // Bits in the MAC_REG_GPIOCTL register
-//
 #define GPIO0_MD            0x01
 #define GPIO0_DATA          0x02
 #define GPIO0_INTMD         0x04
 #define GPIO1_MD            0x10
 #define GPIO1_DATA          0x20
 
-//
 // Bits in the MSRCTL register
-//
 #define MSRCTL_FINISH       0x80
 #define MSRCTL_READY        0x40
 #define MSRCTL_RADARDETECT  0x20
@@ -562,9 +502,8 @@
 #define MSRCTL_QUIETRPT     0x04
 #define MSRCTL_QUIETINT     0x02
 #define MSRCTL_QUIETEN      0x01
-//
+
 // Bits in the MSRCTL1 register
-//
 #define MSRCTL1_TXPWR       0x08
 #define MSRCTL1_CSAPAREN    0x04
 #define MSRCTL1_TXPAUSE     0x01
@@ -605,9 +544,7 @@
 // wait time within loop
 #define CB_DELAY_LOOP_WAIT  10 /* 10ms */
 
-//
 // revision id
-//
 #define REV_ID_VT3253_A0    0x00
 #define REV_ID_VT3253_A1    0x01
 #define REV_ID_VT3253_B0    0x08
-- 
2.2.1

