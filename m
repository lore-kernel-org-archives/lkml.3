Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaHGGdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:33:09 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58026 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHGGdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:33:07 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <oort10@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH] staging:r819xU: coding style: Fixed commenting style
Date: Thu, 7 Aug 2014 12:15:57 +0530
Message-ID: <1407393957-27948-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 07 Aug 2014 06:33:06.0545 (UTC) FILETIME=[72AD6610:01CFB209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r819xU_phyreg.h file that fixes
commenting style warning

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/staging/rtl8192u/r819xU_phyreg.h | 188 ++++++++++++++++---------------
 1 file changed, 97 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_phyreg.h b/drivers/staging/rtl8192u/r819xU_phyreg.h
index 64285d6..f07d2f1 100644
--- a/drivers/staging/rtl8192u/r819xU_phyreg.h
+++ b/drivers/staging/rtl8192u/r819xU_phyreg.h
@@ -2,10 +2,10 @@
 #define _R819XU_PHYREG_H
 
 
-#define   RF_DATA				0x1d4					// FW will write RF data in the register.
+#define   RF_DATA				0x1d4					/* FW will write RF data in the register.*/
 
-//Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF
-//page 1
+/* Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF */
+/* page 1 */
 #define rPMAC_Reset				0x100
 #define rPMAC_TxStart				0x104
 #define rPMAC_TxLegacySIG			0x108
@@ -34,15 +34,16 @@
 #define rPMAC_CCKCRxRC32OK			0x188
 #define rPMAC_TxStatus				0x18c
 
-//page8
-#define rFPGA0_RFMOD				0x800  //RF mode & CCK TxSC
+/* page8 */
+#define rFPGA0_RFMOD				0x800  /* RF mode & CCK TxSC */
 #define rFPGA0_TxInfo				0x804
 #define rFPGA0_PSDFunction			0x808
 #define rFPGA0_TxGainStage			0x80c
 #define rFPGA0_RFTiming1			0x810
 #define rFPGA0_RFTiming2			0x814
-//#define rFPGA0_XC_RFTiming			0x818
-//#define rFPGA0_XD_RFTiming			0x81c
+/* #define rFPGA0_XC_RFTiming			0x818
+ * #define rFPGA0_XD_RFTiming			0x81c
+ */
 #define rFPGA0_XA_HSSIParameter1	0x820
 #define rFPGA0_XA_HSSIParameter2	0x824
 #define rFPGA0_XB_HSSIParameter1	0x828
@@ -79,51 +80,51 @@
 #define rFPGA0_XAB_RFInterfaceRB	0x8e0
 #define rFPGA0_XCD_RFInterfaceRB	0x8e4
 
-//page 9
-#define rFPGA1_RFMOD				0x900  //RF mode & OFDM TxSC
+/* page 9 */
+#define rFPGA1_RFMOD				0x900  /* RF mode & OFDM TxSC */
 #define rFPGA1_TxBlock				0x904
 #define rFPGA1_DebugSelect			0x908
 #define rFPGA1_TxInfo				0x90c
 
-//page a
+/* page a */
 #define rCCK0_System				0xa00
 #define rCCK0_AFESetting			0xa04
 #define rCCK0_CCA					0xa08
-#define rCCK0_RxAGC1				0xa0c  //AGC default value, saturation level
-#define rCCK0_RxAGC2				0xa10  //AGC & DAGC
+#define rCCK0_RxAGC1				0xa0c  /* AGC default value, saturation level */
+#define rCCK0_RxAGC2				0xa10  /* AGC & DAGC */
 #define rCCK0_RxHP				0xa14
-#define rCCK0_DSPParameter1		0xa18  //Timing recovery & Channel estimation threshold
-#define rCCK0_DSPParameter2		0xa1c  //SQ threshold
+#define rCCK0_DSPParameter1		0xa18  /* Timing recovery & Channel estimation threshold */
+#define rCCK0_DSPParameter2		0xa1c  /* SQ threshold */
 #define rCCK0_TxFilter1				0xa20
 #define rCCK0_TxFilter2				0xa24
-#define rCCK0_DebugPort				0xa28  //debug port and Tx filter3
-#define rCCK0_FalseAlarmReport		0xa2c  //0xa2d
+#define rCCK0_DebugPort				0xa28  /* debug port and Tx filter3 */
+#define rCCK0_FalseAlarmReport		0xa2c  /* 0xa2d */
 #define rCCK0_TRSSIReport			0xa50
-#define rCCK0_RxReport				0xa54  //0xa57
-#define rCCK0_FACounterLower		0xa5c  //0xa5b
-#define rCCK0_FACounterUpper		0xa58  //0xa5c
+#define rCCK0_RxReport				0xa54  /* 0xa57 */
+#define rCCK0_FACounterLower		0xa5c  /* 0xa5b */
+#define rCCK0_FACounterUpper		0xa58  /* 0xa5c */
 
-//page c
+/* page c */
 #define rOFDM0_LSTF				0xc00
 #define rOFDM0_TRxPathEnable		0xc04
 #define rOFDM0_TRMuxPar				0xc08
 #define rOFDM0_TRSWIsolation			0xc0c
-#define rOFDM0_XARxAFE				0xc10  //RxIQ DC offset, Rx digital filter, DC notch filter
-#define rOFDM0_XARxIQImbalance		0xc14  //RxIQ imblance matrix
+#define rOFDM0_XARxAFE				0xc10  /* RxIQ DC offset, Rx digital filter, DC notch filter */
+#define rOFDM0_XARxIQImbalance		0xc14  /* RxIQ imblance matrix */
 #define rOFDM0_XBRxAFE				0xc18
 #define rOFDM0_XBRxIQImbalance		0xc1c
 #define rOFDM0_XCRxAFE				0xc20
 #define rOFDM0_XCRxIQImbalance		0xc24
 #define rOFDM0_XDRxAFE				0xc28
 #define rOFDM0_XDRxIQImbalance		0xc2c
-#define rOFDM0_RxDetector1			0xc30  //PD,BW & SBD
-#define rOFDM0_RxDetector2			0xc34  //SBD & Fame Sync.
-#define rOFDM0_RxDetector3			0xc38  //Frame Sync.
-#define rOFDM0_RxDetector4			0xc3c  //PD, SBD, Frame Sync & Short-GI
-#define rOFDM0_RxDSP				0xc40  //Rx Sync Path
-#define rOFDM0_CFOandDAGC		0xc44  //CFO & DAGC
-#define rOFDM0_CCADropThreshold		0xc48 //CCA Drop threshold
-#define rOFDM0_ECCAThreshold		0xc4c // energy CCA
+#define rOFDM0_RxDetector1			0xc30  /* PD,BW & SBD */
+#define rOFDM0_RxDetector2			0xc34  /* SBD & Fame Sync.*/
+#define rOFDM0_RxDetector3			0xc38  /* Frame Sync.*/
+#define rOFDM0_RxDetector4			0xc3c  /* PD, SBD, Frame Sync & Short-GI */
+#define rOFDM0_RxDSP				0xc40  /* Rx Sync Path */
+#define rOFDM0_CFOandDAGC		0xc44  /* CFO & DAGC */
+#define rOFDM0_CCADropThreshold		0xc48 /* CCA Drop threshold */
+#define rOFDM0_ECCAThreshold		0xc4c /* energy CCA */
 #define rOFDM0_XAAGCCore1		0xc50
 #define rOFDM0_XAAGCCore2		0xc54
 #define rOFDM0_XBAGCCore1		0xc58
@@ -156,7 +157,7 @@
 #define rOFDM0_TxCoeff6				0xcb8
 
 
-//page d
+/* page d */
 #define rOFDM1_LSTF				0xd00
 #define rOFDM1_TRxPathEnable		0xd04
 #define rOFDM1_CFO				0xd08
@@ -169,9 +170,10 @@
 #define rOFDM1_PseudoNoiseStateAB 0xd50
 #define rOFDM1_PseudoNoiseStateCD 0xd54
 #define rOFDM1_RxPseudoNoiseWgt   0xd58
-#define rOFDM_PHYCounter1			0xda0  //cca, parity fail
-#define rOFDM_PHYCounter2			0xda4  //rate illegal, crc8 fail
-#define rOFDM_PHYCounter3			0xda8  //MCS not support
+#define rOFDM_PHYCounter1			0xda0  /* cca, parity fail */
+#define rOFDM_PHYCounter2			0xda4  /* rate illegal, crc8 fail */
+
+#define rOFDM_PHYCounter3			0xda8  /* MCS not support */
 #define rOFDM_ShortCFOAB			0xdac
 #define rOFDM_ShortCFOCD			0xdb0
 #define rOFDM_LongCFOAB				0xdb4
@@ -186,7 +188,7 @@
 #define rOFDM_RxEVMCSI				0xdd8
 #define rOFDM_SIGReport				0xddc
 
-//page e
+/* page e */
 #define rTxAGC_Rate18_06			0xe00
 #define rTxAGC_Rate54_24			0xe04
 #define rTxAGC_CCK_Mcs32			0xe08
@@ -196,8 +198,9 @@
 #define rTxAGC_Mcs15_Mcs12			0xe1c
 
 
-//RF
-//Zebra1
+/* RF
+ * Zebra1
+ */
 #define rZebra1_HSSIEnable		0x0
 #define rZebra1_TRxEnable1		0x1
 #define rZebra1_TRxEnable2		0x2
@@ -209,18 +212,19 @@
 #define rZebra1_RxLPF				0xb
 #define rZebra1_RxHPFCorner		0xc
 
-//Zebra4
+/* Zebra4 */
 #define rGlobalCtrl				0
 #define rRTL8256_TxLPF				19
 #define rRTL8256_RxLPF				11
 
-//RTL8258
+/* RTL8258 */
 #define rRTL8258_TxLPF				0x11
 #define rRTL8258_RxLPF				0x13
 #define rRTL8258_RSSILPF		0xa
 
-//Bit Mask
-//page-1
+/* Bit Mask
+ * page-1
+ */
 #define bBBResetB					0x100
 #define bGlobalResetB				0x200
 #define bOFDMTxStart				0x4
@@ -266,7 +270,7 @@
 #define bCCKTxStatus				0x1
 #define bOFDMTxStatus				0x2
 
-//page-8
+/* page-8 */
 #define bRFMOD						0x1
 #define bJapanMode				0x2
 #define bCCKTxSC					0x30
@@ -283,14 +287,14 @@
 #define bRFStart					0x0000f000
 #define bBBStart					0x000000f0
 #define bBBCCKStart				0x0000000f
-#define bPAEnd						0xf          //Reg0x814
+#define bPAEnd						0xf     /* Reg0x814 */
 #define bTREnd						0x0f000000
 #define bRFEnd						0x000f0000
-#define bCCAMask					0x000000f0   //T2R
+#define bCCAMask					0x000000f0   /* T2R */
 #define bR2RCCAMask				0x00000f00
 #define bHSSI_R2TDelay				0xf8000000
 #define bHSSI_T2RDelay				0xf80000
-#define bContTxHSSI				0x400     //chane gain at continue Tx
+#define bContTxHSSI				0x400     /* chane gain at continue Tx */
 #define bIGFromCCK				0x200
 #define bAGCAddress				0x3f
 #define bRxHPTx						0x7000
@@ -301,7 +305,7 @@
 #define b3WireDataLength			0x800
 #define b3WireAddressLength			0x400
 #define b3WireRFPowerDown			0x1
-//#define bHWSISelect				0x8
+/* #define bHWSISelect				0x8 */
 #define b5GPAPEPolarity				0x40000000
 #define b2GPAPEPolarity				0x80000000
 #define bRFSW_TxDefaultAnt			0x3
@@ -312,7 +316,7 @@
 #define bRFSI_3WireClock			0x2
 #define bRFSI_3WireLoad				0x4
 #define bRFSI_3WireRW				0x8
-#define bRFSI_3Wire					0xf  //3-wire total control
+#define bRFSI_3Wire					0xf  /* 3-wire total control */
 #define bRFSI_RFENV				0x10
 #define bRFSI_TRSW				0x20
 #define bRFSI_TRSWB				0x40
@@ -337,12 +341,11 @@
 #define bLSIG_Length				0x1fffe
 #define bLSIG_Parity					0x20
 #define bCCKRxPhase				0x4
-#define bLSSIReadAddress			0x3f000000   //LSSI "Read" Address
-#define bLSSIReadEdge				0x80000000   //LSSI "Read" edge signal
+#define bLSSIReadAddress			0x3f000000   /* LSSI "Read" Address */
+#define bLSSIReadEdge				0x80000000   /* LSSI "Read" edge signal */
 #define bLSSIReadBackData			0xfff
 #define bLSSIReadOKFlag				0x1000
-#define bCCKSampleRate				0x8       //0: 44MHz, 1:88MHz
-
+#define bCCKSampleRate				0x8	/* 0: 44MHz, 1:88MHz */
 #define bRegulator0Standby			0x1
 #define bRegulatorPLLStandby			0x2
 #define bRegulator1Standby			0x4
@@ -395,12 +398,12 @@
 #define bPSDSineToneScale			0x7f000000
 #define bPSDReport					0xffff
 
-//page-9
+/* page-9 */
 #define bOFDMTxSC				0x30000000
 #define bCCKTxOn					0x1
 #define bOFDMTxOn				0x2
-#define bDebugPage				0xfff  //reset debug page and also HWord, LWord
-#define bDebugItem				0xff   //reset debug page and LWord
+#define bDebugPage				0xfff  /* reset debug page and also HWord, LWord */
+#define bDebugItem				0xff   /* reset debug page and LWord */
 #define bAntL					0x10
 #define bAntNonHT					0x100
 #define bAntHT1					0x1000
@@ -408,7 +411,7 @@
 #define bAntHT1S1					0x100000
 #define bAntNonHTS1				0x1000000
 
-//page-a
+/* page-a */
 #define bCCKBBMode				0x3
 #define bCCKTxPowerSaving			0x80
 #define bCCKRxPowerSaving			0x40
@@ -429,7 +432,7 @@
 #define bCCKBistMode				0x80000000
 #define bCCKCCAMask				0x40000000
 #define bCCKTxDACPhase			0x4
-#define bCCKRxADCPhase			0x20000000   //r_rx_clk
+#define bCCKRxADCPhase			0x20000000   /* r_rx_clk */
 #define bCCKr_cp_mode0			0x0100
 #define bCCKTxDCOffset				0xf0
 #define bCCKRxDCOffset				0xf
@@ -443,12 +446,12 @@
 #define bCCKRxIG					0x7f00
 #define bCCKLNAPolarity				0x800000
 #define bCCKRx1stGain				0x7f0000
-#define bCCKRFExtend				0x20000000 //CCK Rx initial gain polarity
+#define bCCKRFExtend				0x20000000 /* CCK Rx initial gain polarity */
 #define bCCKRxAGCSatLevel			0x1f000000
 #define bCCKRxAGCSatCount			0xe0
-#define bCCKRxRFSettle				0x1f       //AGCsamp_dly
+#define bCCKRxRFSettle				0x1f       /* AGCsamp_dly */
 #define bCCKFixedRxAGC				0x8000
-//#define bCCKRxAGCFormat			0x4000   //remove to HSSI register 0x824
+/* #define bCCKRxAGCFormat			0x4000 */   /* remove to HSSI register 0x824 */
 #define bCCKAntennaPolarity			0x2000
 #define bCCKTxFilterType			0x0c00
 #define bCCKRxAGCReportType		0x0300
@@ -489,7 +492,7 @@
 #define bCCKDefaultRxPath			0xc000000
 #define bCCKOptionRxPath			0x3000000
 
-//page c
+/* page c */
 #define bNumOfSTF					0x3
 #define bShift_L					0xc0
 #define bGI_TH						0xc
@@ -591,8 +594,8 @@
 #define bRxHP_BBP1               0x7000
 #define bRxHP_BBP2               0x70000
 #define bRxHP_BBP3               0x700000
-#define bRSSI_H                  0x7f0000     //the threshold for high power
-#define bRSSI_Gen                0x7f000000   //the threshold for ant diversity
+#define bRSSI_H                  0x7f0000     /* the threshold for high power */
+#define bRSSI_Gen                0x7f000000   /* the threshold for ant diversity */
 #define bRxSettle_TRSW           0x7
 #define bRxSettle_LNA            0x38
 #define bRxSettle_RSSI           0x1c0
@@ -626,7 +629,7 @@
 #define bRxPD_Delay_TH1          0x38
 #define bRxPD_Delay_TH2          0x1c0
 #define bRxPD_DC_COUNT_MAX       0x600
-//#define bRxMF_Hold               0x3800
+/* #define bRxMF_Hold               0x3800 */
 #define bRxPD_Delay_TH           0x8000
 #define bRxProcess_Delay         0xf0000
 #define bRxSearchrange_GI2_Early 0x700000
@@ -652,7 +655,7 @@
 
 #define bExtLNAGain              0x7c00
 
-//page d
+/* page d */
 #define bSTBCEn                  0x4
 #define bAntennaMapping          0x10
 #define bNss                     0x20
@@ -662,12 +665,13 @@
 #define bOFDMContinueTx          0x10000000
 #define bOFDMSingleCarrier       0x20000000
 #define bOFDMSingleTone          0x40000000
-//#define bRxPath1                 0x01
-//#define bRxPath2                 0x02
-//#define bRxPath3                 0x04
-//#define bRxPath4                 0x08
-//#define bTxPath1                 0x10
-//#define bTxPath2                 0x20
+/* #define bRxPath1                 0x01
+ * #define bRxPath2                 0x02
+ * #define bRxPath3                 0x04
+ * #define bRxPath4                 0x08
+ * #define bTxPath1                 0x10
+ * #define bTxPath2                 0x20
+ */
 #define bHTDetect                0x100
 #define bCFOEn                   0x10000
 #define bCFOValue                0xfff00000
@@ -680,8 +684,8 @@
 #define bCounter_MCSNoSupport    0xffff
 #define bCounter_FastSync        0xffff
 #define bShortCFO                0xfff
-#define bShortCFOTLength         12   //total
-#define bShortCFOFLength         11   //fraction
+#define bShortCFOTLength         12   /* total */
+#define bShortCFOFLength         11   /* fraction */
 #define bLongCFO                 0x7ff
 #define bLongCFOTLength          11
 #define bLongCFOFLength          11
@@ -758,7 +762,7 @@
 #define bUChCfg                  0x7000000
 #define bUpdEqz                  0x8000000
 
-//page e
+/* page e */
 #define bTxAGCRate18_06			0x7f7f7f7f
 #define bTxAGCRate54_24			0x7f7f7f7f
 #define bTxAGCRateMCS32		0x7f
@@ -769,7 +773,7 @@
 #define bTxAGCRateMCS15_MCS12	0x7f7f7f7f
 
 
-//Rx Pseduo noise
+/* Rx Pseduo noise */
 #define bRxPesudoNoiseOn         0x20000000
 #define bRxPesudoNoise_A         0xff
 #define bRxPesudoNoise_B         0xff00
@@ -780,8 +784,9 @@
 #define bPesudoNoiseState_C      0xffff
 #define bPesudoNoiseState_D      0xffff0000
 
-//RF
-//Zebra1
+/* RF
+ * Zebra1
+ */
 #define bZebra1_HSSIEnable        0x8
 #define bZebra1_TRxControl        0xc00
 #define bZebra1_TRxGainSetting    0x07f
@@ -792,18 +797,18 @@
 #define bZebra1_TxLPFBW           0x400
 #define bZebra1_RxLPFBW           0x600
 
-//Zebra4
+/* Zebra4 */
 #define bRTL8256RegModeCtrl1      0x100
 #define bRTL8256RegModeCtrl0      0x40
 #define bRTL8256_TxLPFBW          0x18
 #define bRTL8256_RxLPFBW          0x600
 
-//RTL8258
+/* RTL8258 */
 #define bRTL8258_TxLPFBW          0xc
 #define bRTL8258_RxLPFBW          0xc00
 #define bRTL8258_RSSILPFBW        0xc0
 
-//byte endable for sb_write
+/* byte endable for sb_write */
 #define bByte0                    0x1
 #define bByte1                    0x2
 #define bByte2                    0x4
@@ -812,7 +817,7 @@
 #define bWord1                    0xc
 #define bDWord                    0xf
 
-//for PutRegsetting & GetRegSetting BitMask
+/* for PutRegsetting & GetRegSetting BitMask */
 #define bMaskByte0                0xff
 #define bMaskByte1                0xff00
 #define bMaskByte2                0xff0000
@@ -821,7 +826,7 @@
 #define bMaskLWord                0x0000ffff
 #define bMaskDWord                0xffffffff
 
-//for PutRFRegsetting & GetRFRegSetting BitMask
+/* for PutRFRegsetting & GetRFRegSetting BitMask */
 #define bMask12Bits               0xfff
 
 #define bEnable                   0x1
@@ -830,14 +835,14 @@
 #define LeftAntenna               0x0
 #define RightAntenna              0x1
 
-#define tCheckTxStatus            500   //500ms
-#define tUpdateRxCounter          100   //100ms
+#define tCheckTxStatus            500   /* 500ms */
+#define tUpdateRxCounter          100   /* 100ms */
 
 #define rateCCK     0
 #define rateOFDM    1
 #define rateHT      2
 
-//define Register-End
+/* define Register-End */
 #define bPMAC_End                 0x1ff
 #define bFPGAPHY0_End             0x8ff
 #define bFPGAPHY1_End             0x9ff
@@ -845,12 +850,13 @@
 #define bOFDMPHY0_End             0xcff
 #define bOFDMPHY1_End             0xdff
 
-//define max debug item in each debug page
-//#define bMaxItem_FPGA_PHY0        0x9
-//#define bMaxItem_FPGA_PHY1        0x3
-//#define bMaxItem_PHY_11B          0x16
-//#define bMaxItem_OFDM_PHY0        0x29
-//#define bMaxItem_OFDM_PHY1        0x0
+/* define max debug item in each debug page
+ * #define bMaxItem_FPGA_PHY0        0x9
+ * #define bMaxItem_FPGA_PHY1        0x3
+ * #define bMaxItem_PHY_11B          0x16
+ * #define bMaxItem_OFDM_PHY0        0x29
+ * #define bMaxItem_OFDM_PHY1        0x0
+ */
 
 #define bPMACControl              0x0
 #define bWMACControl              0x1
@@ -868,4 +874,4 @@
 #define		rRTL8256TxBBBW             19
 #define		bRTL8256TxBBBW			0x18
 
-#endif	//__INC_HAL8190PCIPHYREG_H
+#endif	/* __INC_HAL8190PCIPHYREG_H */
-- 
1.7.11.7

