Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbbAOQcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:32:13 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:35137 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbbAOQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:32:05 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:32 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Staging: vt6655: Checkpatch fix: empty c99 comments
Date: Fri, 16 Jan 2015 03:29:22 +1100
Message-Id: <1421339367-23521-3-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
References: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some of the following checkpatch.pl errors in mac.h:
ERROR: do not use C99 // comments

This patch truncates statements which are followed by empty c99
comments.

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 This patch contains several checkpatch errors which are fixed later
 in the series. 

 drivers/staging/vt6655/mac.h | 354 +++++++++++++++++++++----------------------
 1 file changed, 177 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 0f1d4a5..359e3f2 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -70,14 +70,14 @@
 #define MAC_REG_TMCTL1      0x19
 #define MAC_REG_TMDATA0     0x1C
 // MAC Parameter related
-#define MAC_REG_LRT         0x20        //
-#define MAC_REG_SRT         0x21        //
-#define MAC_REG_SIFS        0x22        //
-#define MAC_REG_DIFS        0x23        //
-#define MAC_REG_EIFS        0x24        //
-#define MAC_REG_SLOT        0x25        //
-#define MAC_REG_BI          0x26        //
-#define MAC_REG_CWMAXMIN0   0x28        //
+#define MAC_REG_LRT         0x20
+#define MAC_REG_SRT         0x21
+#define MAC_REG_SIFS        0x22
+#define MAC_REG_DIFS        0x23
+#define MAC_REG_EIFS        0x24
+#define MAC_REG_SLOT        0x25
+#define MAC_REG_BI          0x26
+#define MAC_REG_CWMAXMIN0   0x28
 #define MAC_REG_LINKOFFTOTM 0x2A
 #define MAC_REG_SWTMOT      0x2B
 #define MAC_REG_MIBCNTR     0x2C
@@ -86,25 +86,25 @@
 #define MAC_REG_ACKFAILCNT  0x2E
 #define MAC_REG_FCSERRCNT   0x2F
 // TSF Related
-#define MAC_REG_TSFCNTR     0x30        //
-#define MAC_REG_NEXTTBTT    0x38        //
-#define MAC_REG_TSFOFST     0x40        //
-#define MAC_REG_TFTCTL      0x48        //
+#define MAC_REG_TSFCNTR     0x30
+#define MAC_REG_NEXTTBTT    0x38
+#define MAC_REG_TSFOFST     0x40
+#define MAC_REG_TFTCTL      0x48
 // WMAC Control/Status Related
-#define MAC_REG_ENCFG       0x4C        //
-#define MAC_REG_PAGE1SEL    0x4F        //
-#define MAC_REG_CFG         0x50        //
-#define MAC_REG_TEST        0x52        //
-#define MAC_REG_HOSTCR      0x54        //
-#define MAC_REG_MACCR       0x55        //
-#define MAC_REG_RCR         0x56        //
-#define MAC_REG_TCR         0x57        //
-#define MAC_REG_IMR         0x58        //
+#define MAC_REG_ENCFG       0x4C
+#define MAC_REG_PAGE1SEL    0x4F
+#define MAC_REG_CFG         0x50
+#define MAC_REG_TEST        0x52
+#define MAC_REG_HOSTCR      0x54
+#define MAC_REG_MACCR       0x55
+#define MAC_REG_RCR         0x56
+#define MAC_REG_TCR         0x57
+#define MAC_REG_IMR         0x58
 #define MAC_REG_ISR         0x5C
 // Power Saving Related
-#define MAC_REG_PSCFG       0x60        //
-#define MAC_REG_PSCTL       0x61        //
-#define MAC_REG_PSPWRSIG    0x62        //
+#define MAC_REG_PSCFG       0x60
+#define MAC_REG_PSCTL       0x61
+#define MAC_REG_PSPWRSIG    0x62
 #define MAC_REG_BBCR13      0x63
 #define MAC_REG_AIDATIM     0x64
 #define MAC_REG_PWBT        0x66
@@ -113,30 +113,30 @@
 #define MAC_REG_SYNSPACCNT  0x6A
 #define MAC_REG_WAKSYNOPT   0x6B
 // Baseband/IF Control Group
-#define MAC_REG_BBREGCTL    0x6C        //
+#define MAC_REG_BBREGCTL    0x6C
 #define MAC_REG_CHANNEL     0x6D
 #define MAC_REG_BBREGADR    0x6E
 #define MAC_REG_BBREGDATA   0x6F
-#define MAC_REG_IFREGCTL    0x70        //
-#define MAC_REG_IFDATA      0x71        //
-#define MAC_REG_ITRTMSET    0x74        //
+#define MAC_REG_IFREGCTL    0x70
+#define MAC_REG_IFDATA      0x71
+#define MAC_REG_ITRTMSET    0x74
 #define MAC_REG_PAPEDELAY   0x77
-#define MAC_REG_SOFTPWRCTL  0x78        //
-#define MAC_REG_GPIOCTL0    0x7A        //
-#define MAC_REG_GPIOCTL1    0x7B        //
+#define MAC_REG_SOFTPWRCTL  0x78
+#define MAC_REG_GPIOCTL0    0x7A
+#define MAC_REG_GPIOCTL1    0x7B
 
 // MAC DMA Related Group
-#define MAC_REG_TXDMACTL0   0x7C        //
-#define MAC_REG_TXDMAPTR0   0x80        //
-#define MAC_REG_AC0DMACTL   0x84        //
-#define MAC_REG_AC0DMAPTR   0x88        //
-#define MAC_REG_BCNDMACTL   0x8C        //
-#define MAC_REG_BCNDMAPTR   0x90        //
-#define MAC_REG_RXDMACTL0   0x94        //
-#define MAC_REG_RXDMAPTR0   0x98        //
-#define MAC_REG_RXDMACTL1   0x9C        //
-#define MAC_REG_RXDMAPTR1   0xA0        //
-#define MAC_REG_SYNCDMACTL  0xA4        //
+#define MAC_REG_TXDMACTL0   0x7C
+#define MAC_REG_TXDMAPTR0   0x80
+#define MAC_REG_AC0DMACTL   0x84
+#define MAC_REG_AC0DMAPTR   0x88
+#define MAC_REG_BCNDMACTL   0x8C
+#define MAC_REG_BCNDMAPTR   0x90
+#define MAC_REG_RXDMACTL0   0x94
+#define MAC_REG_RXDMAPTR0   0x98
+#define MAC_REG_RXDMACTL1   0x9C
+#define MAC_REG_RXDMAPTR1   0xA0
+#define MAC_REG_SYNCDMACTL  0xA4
 #define MAC_REG_SYNCDMAPTR  0xA8
 #define MAC_REG_ATIMDMACTL  0xAC
 #define MAC_REG_ATIMDMAPTR  0xB0
@@ -217,20 +217,20 @@
 #define BCFG1_CISDLYEN      0x01
 
 // Bits in RAMBIST registers
-#define BISTCMD_TSTPAT5     0x00        //
-#define BISTCMD_TSTPATA     0x80        //
-#define BISTCMD_TSTERR      0x20        //
-#define BISTCMD_TSTPATF     0x18        //
-#define BISTCMD_TSTPAT0     0x10        //
-#define BISTCMD_TSTMODE     0x04        //
-#define BISTCMD_TSTITTX     0x03        //
-#define BISTCMD_TSTATRX     0x02        //
-#define BISTCMD_TSTATTX     0x01        //
-#define BISTCMD_TSTRX       0x00        //
-#define BISTSR0_BISTGO      0x01        //
-#define BISTSR1_TSTSR       0x01        //
-#define BISTSR2_CMDPRTEN    0x02        //
-#define BISTSR2_RAMTSTEN    0x01        //
+#define BISTCMD_TSTPAT5     0x00
+#define BISTCMD_TSTPATA     0x80
+#define BISTCMD_TSTERR      0x20
+#define BISTCMD_TSTPATF     0x18
+#define BISTCMD_TSTPAT0     0x10
+#define BISTCMD_TSTMODE     0x04
+#define BISTCMD_TSTITTX     0x03
+#define BISTCMD_TSTATRX     0x02
+#define BISTCMD_TSTATTX     0x01
+#define BISTCMD_TSTRX       0x00
+#define BISTSR0_BISTGO      0x01
+#define BISTSR1_TSTSR       0x01
+#define BISTSR2_CMDPRTEN    0x02
+#define BISTSR2_RAMTSTEN    0x01
 
 //
 // Bits in the I2MCFG EEPROM register
@@ -275,14 +275,14 @@
 //
 // Bits in the TFTCTL register
 //
-#define TFTCTL_HWUTSF       0x80        //
+#define TFTCTL_HWUTSF       0x80
 #define TFTCTL_TBTTSYNC     0x40
 #define TFTCTL_HWUTSFEN     0x20
-#define TFTCTL_TSFCNTRRD    0x10        //
-#define TFTCTL_TBTTSYNCEN   0x08        //
-#define TFTCTL_TSFSYNCEN    0x04        //
-#define TFTCTL_TSFCNTRST    0x02        //
-#define TFTCTL_TSFCNTREN    0x01        //
+#define TFTCTL_TSFCNTRRD    0x10
+#define TFTCTL_TBTTSYNCEN   0x08
+#define TFTCTL_TSFSYNCEN    0x04
+#define TFTCTL_TSFCNTRST    0x02
+#define TFTCTL_TSFCNTREN    0x01
 
 //
 // Bits in the EnhanceCFG register
@@ -321,21 +321,21 @@
 //
 // Bits in the TEST register
 //
-#define TEST_LBEXT          0x80        //
-#define TEST_LBINT          0x40        //
-#define TEST_LBNONE         0x00        //
-#define TEST_SOFTINT        0x20        //
-#define TEST_CONTTX         0x10        //
-#define TEST_TXPE           0x08        //
-#define TEST_NAVDIS         0x04        //
-#define TEST_NOCTS          0x02        //
-#define TEST_NOACK          0x01        //
+#define TEST_LBEXT          0x80
+#define TEST_LBINT          0x40
+#define TEST_LBNONE         0x00
+#define TEST_SOFTINT        0x20
+#define TEST_CONTTX         0x10
+#define TEST_TXPE           0x08
+#define TEST_NAVDIS         0x04
+#define TEST_NOCTS          0x02
+#define TEST_NOACK          0x01
 
 //
 // Bits in the HOSTCR register
 //
-#define HOSTCR_TXONST       0x80        //
-#define HOSTCR_RXONST       0x40        //
+#define HOSTCR_TXONST       0x80
+#define HOSTCR_RXONST       0x40
 #define HOSTCR_ADHOC        0x20        // Network Type 1 = Ad-hoc
 #define HOSTCR_AP           0x10        // Port Type 1 = AP
 #define HOSTCR_TXON         0x08        //0000 1000
@@ -346,167 +346,167 @@
 //
 // Bits in the MACCR register
 //
-#define MACCR_SYNCFLUSHOK   0x04        //
-#define MACCR_SYNCFLUSH     0x02        //
-#define MACCR_CLRNAV        0x01        //
+#define MACCR_SYNCFLUSHOK   0x04
+#define MACCR_SYNCFLUSH     0x02
+#define MACCR_CLRNAV        0x01
 
 // Bits in the MAC_REG_GPIOCTL0 register
 //
-#define LED_ACTSET           0x01        //
-#define LED_RFOFF            0x02        //
-#define LED_NOCONNECT        0x04        //
+#define LED_ACTSET           0x01
+#define LED_RFOFF            0x02
+#define LED_NOCONNECT        0x04
 //
 // Bits in the RCR register
 //
 #define RCR_SSID            0x80
-#define RCR_RXALLTYPE       0x40        //
-#define RCR_UNICAST         0x20        //
-#define RCR_BROADCAST       0x10        //
-#define RCR_MULTICAST       0x08        //
-#define RCR_WPAERR          0x04        //
-#define RCR_ERRCRC          0x02        //
-#define RCR_BSSID           0x01        //
+#define RCR_RXALLTYPE       0x40
+#define RCR_UNICAST         0x20
+#define RCR_BROADCAST       0x10
+#define RCR_MULTICAST       0x08
+#define RCR_WPAERR          0x04
+#define RCR_ERRCRC          0x02
+#define RCR_BSSID           0x01
 
 //
 // Bits in the TCR register
 //
-#define TCR_SYNCDCFOPT      0x02        //
+#define TCR_SYNCDCFOPT      0x02
 #define TCR_AUTOBCNTX       0x01        // Beacon automatically transmit enable
 
 //
 // Bits in the IMR register
 //
-#define IMR_MEASURESTART    0x80000000      //
-#define IMR_QUIETSTART      0x20000000      //
-#define IMR_RADARDETECT     0x10000000      //
-#define IMR_MEASUREEND      0x08000000      //
-#define IMR_SOFTTIMER1      0x00200000      //
+#define IMR_MEASURESTART    0x80000000
+#define IMR_QUIETSTART      0x20000000
+#define IMR_RADARDETECT     0x10000000
+#define IMR_MEASUREEND      0x08000000
+#define IMR_SOFTTIMER1      0x00200000
 #define IMR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
-#define IMR_RXNOBUF         0x00000800      //
-#define IMR_MIBNEARFULL     0x00000400      //
-#define IMR_SOFTINT         0x00000200      //
-#define IMR_FETALERR        0x00000100      //
-#define IMR_WATCHDOG        0x00000080      //
-#define IMR_SOFTTIMER       0x00000040      //
-#define IMR_GPIO            0x00000020      //
-#define IMR_TBTT            0x00000010      //
-#define IMR_RXDMA0          0x00000008      //
-#define IMR_BNTX            0x00000004      //
-#define IMR_AC0DMA          0x00000002      //
-#define IMR_TXDMA0          0x00000001      //
+#define IMR_RXNOBUF         0x00000800
+#define IMR_MIBNEARFULL     0x00000400
+#define IMR_SOFTINT         0x00000200
+#define IMR_FETALERR        0x00000100
+#define IMR_WATCHDOG        0x00000080
+#define IMR_SOFTTIMER       0x00000040
+#define IMR_GPIO            0x00000020
+#define IMR_TBTT            0x00000010
+#define IMR_RXDMA0          0x00000008
+#define IMR_BNTX            0x00000004
+#define IMR_AC0DMA          0x00000002
+#define IMR_TXDMA0          0x00000001
 
 //
 // Bits in the ISR register
 //
 
-#define ISR_MEASURESTART    0x80000000      //
-#define ISR_QUIETSTART      0x20000000      //
-#define ISR_RADARDETECT     0x10000000      //
-#define ISR_MEASUREEND      0x08000000      //
-#define ISR_SOFTTIMER1      0x00200000      //
+#define ISR_MEASURESTART    0x80000000
+#define ISR_QUIETSTART      0x20000000
+#define ISR_RADARDETECT     0x10000000
+#define ISR_MEASUREEND      0x08000000
+#define ISR_SOFTTIMER1      0x00200000
 #define ISR_RXDMA1          0x00001000      //0000 0000 0001 0000 0000 0000
 #define ISR_RXNOBUF         0x00000800      //0000 0000 0000 1000 0000 0000
 #define ISR_MIBNEARFULL     0x00000400      //0000 0000 0000 0100 0000 0000
-#define ISR_SOFTINT         0x00000200      //
-#define ISR_FETALERR        0x00000100      //
-#define ISR_WATCHDOG        0x00000080      //
-#define ISR_SOFTTIMER       0x00000040      //
-#define ISR_GPIO            0x00000020      //
-#define ISR_TBTT            0x00000010      //
-#define ISR_RXDMA0          0x00000008      //
-#define ISR_BNTX            0x00000004      //
-#define ISR_AC0DMA          0x00000002      //
-#define ISR_TXDMA0          0x00000001      //
+#define ISR_SOFTINT         0x00000200
+#define ISR_FETALERR        0x00000100
+#define ISR_WATCHDOG        0x00000080
+#define ISR_SOFTTIMER       0x00000040
+#define ISR_GPIO            0x00000020
+#define ISR_TBTT            0x00000010
+#define ISR_RXDMA0          0x00000008
+#define ISR_BNTX            0x00000004
+#define ISR_AC0DMA          0x00000002
+#define ISR_TXDMA0          0x00000001
 
 //
 // Bits in the PSCFG register
 //
-#define PSCFG_PHILIPMD      0x40        //
-#define PSCFG_WAKECALEN     0x20        //
-#define PSCFG_WAKETMREN     0x10        //
-#define PSCFG_BBPSPROG      0x08        //
-#define PSCFG_WAKESYN       0x04        //
-#define PSCFG_SLEEPSYN      0x02        //
-#define PSCFG_AUTOSLEEP     0x01        //
+#define PSCFG_PHILIPMD      0x40
+#define PSCFG_WAKECALEN     0x20
+#define PSCFG_WAKETMREN     0x10
+#define PSCFG_BBPSPROG      0x08
+#define PSCFG_WAKESYN       0x04
+#define PSCFG_SLEEPSYN      0x02
+#define PSCFG_AUTOSLEEP     0x01
 
 //
 // Bits in the PSCTL register
 //
-#define PSCTL_WAKEDONE      0x20        //
-#define PSCTL_PS            0x10        //
-#define PSCTL_GO2DOZE       0x08        //
-#define PSCTL_LNBCN         0x04        //
-#define PSCTL_ALBCN         0x02        //
-#define PSCTL_PSEN          0x01        //
+#define PSCTL_WAKEDONE      0x20
+#define PSCTL_PS            0x10
+#define PSCTL_GO2DOZE       0x08
+#define PSCTL_LNBCN         0x04
+#define PSCTL_ALBCN         0x02
+#define PSCTL_PSEN          0x01
 
 //
 // Bits in the PSPWSIG register
 //
-#define PSSIG_WPE3          0x80        //
-#define PSSIG_WPE2          0x40        //
-#define PSSIG_WPE1          0x20        //
-#define PSSIG_WRADIOPE      0x10        //
-#define PSSIG_SPE3          0x08        //
-#define PSSIG_SPE2          0x04        //
-#define PSSIG_SPE1          0x02        //
-#define PSSIG_SRADIOPE      0x01        //
+#define PSSIG_WPE3          0x80
+#define PSSIG_WPE2          0x40
+#define PSSIG_WPE1          0x20
+#define PSSIG_WRADIOPE      0x10
+#define PSSIG_SPE3          0x08
+#define PSSIG_SPE2          0x04
+#define PSSIG_SPE1          0x02
+#define PSSIG_SRADIOPE      0x01
 
 //
 // Bits in the BBREGCTL register
 //
-#define BBREGCTL_DONE       0x04        //
-#define BBREGCTL_REGR       0x02        //
-#define BBREGCTL_REGW       0x01        //
+#define BBREGCTL_DONE       0x04
+#define BBREGCTL_REGR       0x02
+#define BBREGCTL_REGW       0x01
 
 //
 // Bits in the IFREGCTL register
 //
-#define IFREGCTL_DONE       0x04        //
-#define IFREGCTL_IFRF       0x02        //
-#define IFREGCTL_REGW       0x01        //
+#define IFREGCTL_DONE       0x04
+#define IFREGCTL_IFRF       0x02
+#define IFREGCTL_REGW       0x01
 
 //
 // Bits in the SOFTPWRCTL register
 //
-#define SOFTPWRCTL_RFLEOPT      0x0800  //
-#define SOFTPWRCTL_TXPEINV      0x0200  //
-#define SOFTPWRCTL_SWPECTI      0x0100  //
-#define SOFTPWRCTL_SWPAPE       0x0020  //
-#define SOFTPWRCTL_SWCALEN      0x0010  //
-#define SOFTPWRCTL_SWRADIO_PE   0x0008  //
-#define SOFTPWRCTL_SWPE2        0x0004  //
-#define SOFTPWRCTL_SWPE1        0x0002  //
-#define SOFTPWRCTL_SWPE3        0x0001  //
+#define SOFTPWRCTL_RFLEOPT      0x0800
+#define SOFTPWRCTL_TXPEINV      0x0200
+#define SOFTPWRCTL_SWPECTI      0x0100
+#define SOFTPWRCTL_SWPAPE       0x0020
+#define SOFTPWRCTL_SWCALEN      0x0010
+#define SOFTPWRCTL_SWRADIO_PE   0x0008
+#define SOFTPWRCTL_SWPE2        0x0004
+#define SOFTPWRCTL_SWPE1        0x0002
+#define SOFTPWRCTL_SWPE3        0x0001
 
 //
 // Bits in the GPIOCTL1 register
 //
-#define GPIO1_DATA1             0x20    //
-#define GPIO1_MD1               0x10    //
-#define GPIO1_DATA0             0x02    //
-#define GPIO1_MD0               0x01    //
+#define GPIO1_DATA1             0x20
+#define GPIO1_MD1               0x10
+#define GPIO1_DATA0             0x02
+#define GPIO1_MD0               0x01
 
 //
 // Bits in the DMACTL register
 //
-#define DMACTL_CLRRUN       0x00080000  //
-#define DMACTL_RUN          0x00000008  //
-#define DMACTL_WAKE         0x00000004  //
-#define DMACTL_DEAD         0x00000002  //
-#define DMACTL_ACTIVE       0x00000001  //
+#define DMACTL_CLRRUN       0x00080000
+#define DMACTL_RUN          0x00000008
+#define DMACTL_WAKE         0x00000004
+#define DMACTL_DEAD         0x00000002
+#define DMACTL_ACTIVE       0x00000001
 //
 // Bits in the RXDMACTL0 register
 //
-#define RX_PERPKT           0x00000100  //
-#define RX_PERPKTCLR        0x01000000  //
+#define RX_PERPKT           0x00000100
+#define RX_PERPKTCLR        0x01000000
 //
 // Bits in the BCNDMACTL register
 //
-#define BEACON_READY        0x01        //
+#define BEACON_READY        0x01
 //
 // Bits in the MISCFFCTL register
 //
-#define MISCFFCTL_WRITE     0x0001      //
+#define MISCFFCTL_WRITE     0x0001
 
 //
 // Bits in WAKEUPEN0
@@ -545,11 +545,11 @@
 //
 // Bits in the MAC_REG_GPIOCTL register
 //
-#define GPIO0_MD            0x01        //
-#define GPIO0_DATA          0x02        //
-#define GPIO0_INTMD         0x04        //
-#define GPIO1_MD            0x10        //
-#define GPIO1_DATA          0x20        //
+#define GPIO0_MD            0x01
+#define GPIO0_DATA          0x02
+#define GPIO0_INTMD         0x04
+#define GPIO1_MD            0x10
+#define GPIO1_DATA          0x20
 
 //
 // Bits in the MSRCTL register
@@ -570,9 +570,9 @@
 #define MSRCTL1_TXPAUSE     0x01
 
 // Loopback mode
-#define MAC_LB_EXT          0x02        //
-#define MAC_LB_INTERNAL     0x01        //
-#define MAC_LB_NONE         0x00        //
+#define MAC_LB_EXT          0x02
+#define MAC_LB_INTERNAL     0x01
+#define MAC_LB_NONE         0x00
 
 #define Default_BI              0x200
 
@@ -600,7 +600,7 @@
 			    IMR_TXDMA0)
 
 // max time out delay time
-#define W_MAX_TIMEOUT       0xFFF0U     //
+#define W_MAX_TIMEOUT       0xFFF0U
 
 // wait time within loop
 #define CB_DELAY_LOOP_WAIT  10          // 10ms
-- 
2.2.1

