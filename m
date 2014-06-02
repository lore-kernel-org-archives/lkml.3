Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaFBDHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:07:08 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:50796 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaFBDHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:07:07 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: vt6655: replace C99 style comments
Date: Sun,  1 Jun 2014 23:06:57 -0400
Message-Id: <1401678417-28571-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/baseband.c |  300 ++++++++++++++++++-------------------
 1 file changed, 150 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 6f95fb6..490ca96 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -57,7 +57,7 @@
 #include "rf.h"
 
 /*---------------------  Static Definitions -------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
+/* static int          msglevel                =MSG_LEVEL_DEBUG; */
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Classes  ----------------------------*/
@@ -785,7 +785,7 @@ unsigned char byVT3253B0_RFMD[CB_VT3253B0_INIT_FOR_RFMD][2] = {
 };
 
 #define CB_VT3253B0_AGC_FOR_RFMD2959 195
-// For RFMD2959
+/* For RFMD2959 */
 unsigned char byVT3253B0_AGC4_RFMD2959[CB_VT3253B0_AGC_FOR_RFMD2959][2] = {
 	{0xF0, 0x00},
 	{0xF1, 0x3E},
@@ -985,7 +985,7 @@ unsigned char byVT3253B0_AGC4_RFMD2959[CB_VT3253B0_AGC_FOR_RFMD2959][2] = {
 };
 
 #define CB_VT3253B0_INIT_FOR_AIROHA2230 256
-// For AIROHA
+/* For AIROHA */
 unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 	{0x00, 0x31},
 	{0x01, 0x00},
@@ -1095,7 +1095,7 @@ unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 	{0x69, 0x00},
 	{0x6a, 0x00},
 	{0x6b, 0x00},
-	{0x6c, 0x00}, //RobertYu:20050125, request by JJSue
+	{0x6c, 0x00}, /* RobertYu:20050125, request by JJSue */
 	{0x6d, 0x03},
 	{0x6e, 0x01},
 	{0x6f, 0x00},
@@ -1246,7 +1246,7 @@ unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 };
 
 #define CB_VT3253B0_INIT_FOR_UW2451 256
-//For UW2451
+/* For UW2451 */
 unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 	{0x00, 0x31},
 	{0x01, 0x00},
@@ -1356,7 +1356,7 @@ unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 	{0x69, 0x00},
 	{0x6a, 0x00},
 	{0x6b, 0x00},
-	{0x6c, 0x00}, //RobertYu:20050125, request by JJSue
+	{0x6c, 0x00}, /* RobertYu:20050125, request by JJSue */
 	{0x6d, 0x03},
 	{0x6e, 0x01},
 	{0x6f, 0x00},
@@ -1507,7 +1507,7 @@ unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 };
 
 #define CB_VT3253B0_AGC 193
-// For AIROHA
+/* For AIROHA */
 unsigned char byVT3253B0_AGC[CB_VT3253B0_AGC][2] = {
 	{0xF0, 0x00},
 	{0xF1, 0x00},
@@ -1783,29 +1783,29 @@ BBuGetFrameTime(
 
 	uRate = (unsigned int)awcFrameTime[uRateIdx];
 
-	if (uRateIdx <= 3) {          //CCK mode
-		if (byPreambleType == 1) //Short
+	if (uRateIdx <= 3) {          /* CCK mode */
+		if (byPreambleType == 1) /* Short */
 			uPreamble = 96;
 		else
 			uPreamble = 192;
 
-		uFrameTime = (cbFrameLength * 80) / uRate;  //?????
+		uFrameTime = (cbFrameLength * 80) / uRate;  /* ????? */
 		uTmp = (uFrameTime * uRate) / 80;
 		if (cbFrameLength != uTmp)
 			uFrameTime++;
 
 		return uPreamble + uFrameTime;
 	} else {
-		uFrameTime = (cbFrameLength * 8 + 22) / uRate;   //????????
+		uFrameTime = (cbFrameLength * 8 + 22) / uRate; /* ???????? */
 		uTmp = ((uFrameTime * uRate) - 22) / 8;
 		if (cbFrameLength != uTmp)
 			uFrameTime++;
 
-		uFrameTime = uFrameTime * 4;    //???????
+		uFrameTime = uFrameTime * 4;    /* ??????? */
 		if (byPktType != PK_TYPE_11A)
-			uFrameTime += 6;     //??????
+			uFrameTime += 6;     /* ?????? */
 
-		return 20 + uFrameTime; //??????
+		return 20 + uFrameTime; /* ?????? */
 	}
 }
 
@@ -1856,7 +1856,7 @@ BBvCalculateParameter(
 		cbUsCount = cbBitCount / 2;
 		if (byPreambleType == 1)
 			*pbyPhySgn = 0x09;
-		else // long preamble
+		else /* long preamble */
 			*pbyPhySgn = 0x01;
 		break;
 
@@ -1869,7 +1869,7 @@ BBvCalculateParameter(
 			cbUsCount++;
 		if (byPreambleType == 1)
 			*pbyPhySgn = 0x0a;
-		else // long preamble
+		else /* long preamble */
 			*pbyPhySgn = 0x02;
 		break;
 
@@ -1886,79 +1886,79 @@ BBvCalculateParameter(
 		}
 		if (byPreambleType == 1)
 			*pbyPhySgn = 0x0b;
-		else // long preamble
+		else /* long preamble */
 			*pbyPhySgn = 0x03;
 		break;
 
 	case RATE_6M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9B; //1001 1011
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8B; //1000 1011
+		if (byPacketType == PK_TYPE_11A) { /*11a, 5GHZ */
+			*pbyPhySgn = 0x9B; /* 1001 1011 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8B; /* 1000 1011 */
 		}
 		break;
 
 	case RATE_9M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9F; //1001 1111
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8F; //1000 1111
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9F; /* 1001 1111 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8F; /* 1000 1111 */
 		}
 		break;
 
 	case RATE_12M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9A; //1001 1010
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8A; //1000 1010
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9A; /* 1001 1010 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8A; /* 1000 1010 */
 		}
 		break;
 
 	case RATE_18M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9E; //1001 1110
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8E; //1000 1110
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9E; /* 1001 1110 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8E; /* 1000 1110 */
 		}
 		break;
 
 	case RATE_24M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x99; //1001 1001
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x89; //1000 1001
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x99; /* 1001 1001 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x89; /* 1000 1001 */
 		}
 		break;
 
 	case RATE_36M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9D; //1001 1101
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8D; //1000 1101
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9D; /* 1001 1101 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8D; /* 1000 1101 */
 		}
 		break;
 
 	case RATE_48M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x98; //1001 1000
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x88; //1000 1000
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x98; /* 1001 1000 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x88; /* 1000 1000 */
 		}
 		break;
 
 	case RATE_54M:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9C; //1001 1100
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8C; //1000 1100
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9C; /* 1001 1100 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8C; /* 1000 1100 */
 		}
 		break;
 
 	default:
-		if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-			*pbyPhySgn = 0x9C; //1001 1100
-		} else {//11g, 2.4GHZ
-			*pbyPhySgn = 0x8C; //1000 1100
+		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
+			*pbyPhySgn = 0x9C; /* 1001 1100 */
+		} else {/* 11g, 2.4GHZ */
+			*pbyPhySgn = 0x8C; /* 1000 1100 */
 		}
 		break;
 	}
@@ -1992,19 +1992,19 @@ bool BBbReadEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned ch
 	unsigned short ww;
 	unsigned char byValue;
 
-	// BB reg offset
+	/* BB reg offset */
 	VNSvOutPortB(dwIoBase + MAC_REG_BBREGADR, byBBAddr);
 
-	// turn on REGR
+	/* turn on REGR */
 	MACvRegBitsOn(dwIoBase, MAC_REG_BBREGCTL, BBREGCTL_REGR);
-	// W_MAX_TIMEOUT is the timeout period
+	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_BBREGCTL, &byValue);
 		if (byValue & BBREGCTL_DONE)
 			break;
 	}
 
-	// get BB data
+	/* get BB data */
 	VNSvInPortB(dwIoBase + MAC_REG_BBREGDATA, pbyData);
 
 	if (ww == W_MAX_TIMEOUT) {
@@ -2034,14 +2034,14 @@ bool BBbWriteEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned c
 	unsigned short ww;
 	unsigned char byValue;
 
-	// BB reg offset
+	/* BB reg offset */
 	VNSvOutPortB(dwIoBase + MAC_REG_BBREGADR, byBBAddr);
-	// set BB data
+	/* set BB data */
 	VNSvOutPortB(dwIoBase + MAC_REG_BBREGDATA, byData);
 
-	// turn on BBREGCTL_REGW
+	/* turn on BBREGCTL_REGW */
 	MACvRegBitsOn(dwIoBase, MAC_REG_BBREGCTL, BBREGCTL_REGW);
-	// W_MAX_TIMEOUT is the timeout period
+	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortB(dwIoBase + MAC_REG_BBREGCTL, &byValue);
 		if (byValue & BBREGCTL_DONE)
@@ -2183,22 +2183,22 @@ bool BBbVT3253Init(PSDevice pDevice)
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
 
-		// Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-		//bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);
-		// Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-		//bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);
-		// Select VC1/VC2, CR215 = 0x02->0x06
+		/* Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
+		/*bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);*/
+		/* Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
+		/*bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);*/
+		/* Select VC1/VC2, CR215 = 0x02->0x06 */
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xd7, 0x06);
 
-		//{{RobertYu:20050125, request by Jack
+		/* {{RobertYu:20050125, request by Jack */
 		bResult &= BBbWriteEmbedded(dwIoBase, 0x90, 0x20);
 		bResult &= BBbWriteEmbedded(dwIoBase, 0x97, 0xeb);
-		//}}
+		/* }} */
 
-		//{{RobertYu:20050221, request by Jack
+		/* {{RobertYu:20050221, request by Jack */
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xa6, 0x00);
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xa8, 0x30);
-		//}}
+		/* }} */
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xb0, 0x58);
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
@@ -2212,7 +2212,7 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[1] = -50;
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
-		//}} RobertYu
+		/* }} RobertYu */
 
 	} else if (byRFType == RF_VT3226) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
@@ -2229,22 +2229,22 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[1] = -48;
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
-		// Fix VT3226 DFC system timing issue
+		/* Fix VT3226 DFC system timing issue */
 		MACvSetRFLE_LatchBase(dwIoBase);
-		//{{ RobertYu: 20050104
+		/* {{ RobertYu: 20050104 */
 	} else if (byRFType == RF_AIROHA7230) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
 
 
-		//{{ RobertYu:20050223, request by JerryChung
-		// Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-		//bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);
-		// Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-		//bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);
-		// Select VC1/VC2, CR215 = 0x02->0x06
+		/* {{ RobertYu:20050223, request by JerryChung */
+		/* Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
+		/*bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);*/
+		/* Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
+		/*bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);*/
+		/* Select VC1/VC2, CR215 = 0x02->0x06 */
 		bResult &= BBbWriteEmbedded(dwIoBase, 0xd7, 0x06);
-		//}}
+		/* }} */
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
@@ -2257,9 +2257,9 @@ bool BBbVT3253Init(PSDevice pDevice)
 		pDevice->ldBmThreshold[1] = -48;
 		pDevice->ldBmThreshold[2] = 0;
 		pDevice->ldBmThreshold[3] = 0;
-		//}} RobertYu
+		/* }} RobertYu */
 	} else {
-		// No VGA Table now
+		/* No VGA Table now */
 		pDevice->bUpdateBBVGA = false;
 		pDevice->abyBBVGA[0] = 0x1C;
 	}
@@ -2314,37 +2314,37 @@ void BBvLoopbackOn(PSDevice pDevice)
 	unsigned char byData;
 	unsigned long dwIoBase = pDevice->PortOffset;
 
-	//CR C9 = 0x00
-	BBbReadEmbedded(dwIoBase, 0xC9, &pDevice->byBBCRc9);//CR201
+	/* CR C9 = 0x00 */
+	BBbReadEmbedded(dwIoBase, 0xC9, &pDevice->byBBCRc9); /* CR201 */
 	BBbWriteEmbedded(dwIoBase, 0xC9, 0);
-	BBbReadEmbedded(dwIoBase, 0x4D, &pDevice->byBBCR4d);//CR77
+	BBbReadEmbedded(dwIoBase, 0x4D, &pDevice->byBBCR4d); /* CR77 */
 	BBbWriteEmbedded(dwIoBase, 0x4D, 0x90);
 
-	//CR 88 = 0x02(CCK), 0x03(OFDM)
-	BBbReadEmbedded(dwIoBase, 0x88, &pDevice->byBBCR88);//CR136
-
-	if (pDevice->uConnectionRate <= RATE_11M) { //CCK
-		// Enable internal digital loopback: CR33 |= 0000 0001
-		BBbReadEmbedded(dwIoBase, 0x21, &byData);//CR33
-		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData | 0x01));//CR33
-		// CR154 = 0x00
-		BBbWriteEmbedded(dwIoBase, 0x9A, 0);   //CR154
-
-		BBbWriteEmbedded(dwIoBase, 0x88, 0x02);//CR239
-	} else { //OFDM
-		// Enable internal digital loopback:CR154 |= 0000 0001
-		BBbReadEmbedded(dwIoBase, 0x9A, &byData);//CR154
-		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData | 0x01));//CR154
-		// CR33 = 0x00
-		BBbWriteEmbedded(dwIoBase, 0x21, 0);   //CR33
-
-		BBbWriteEmbedded(dwIoBase, 0x88, 0x03);//CR239
+	/* CR 88 = 0x02(CCK), 0x03(OFDM) */
+	BBbReadEmbedded(dwIoBase, 0x88, &pDevice->byBBCR88); /* CR136 */
+
+	if (pDevice->uConnectionRate <= RATE_11M) { /* CCK */
+		/* Enable internal digital loopback: CR33 |= 0000 0001 */
+		BBbReadEmbedded(dwIoBase, 0x21, &byData); /* CR33 */
+		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData | 0x01)); /* CR33 */
+		/* CR154 = 0x00 */
+		BBbWriteEmbedded(dwIoBase, 0x9A, 0);    /* CR154 */
+
+		BBbWriteEmbedded(dwIoBase, 0x88, 0x02); /* CR239 */
+	} else { /* OFDM */
+		/* Enable internal digital loopback:CR154 |= 0000 0001 */
+		BBbReadEmbedded(dwIoBase, 0x9A, &byData); /* CR154 */
+		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData | 0x01)); /* CR154 */
+		/* CR33 = 0x00 */
+		BBbWriteEmbedded(dwIoBase, 0x21, 0);    /* CR33 */
+
+		BBbWriteEmbedded(dwIoBase, 0x88, 0x03); /* CR239 */
 	}
 
-	//CR14 = 0x00
-	BBbWriteEmbedded(dwIoBase, 0x0E, 0);//CR14
+	/* CR14 = 0x00 */
+	BBbWriteEmbedded(dwIoBase, 0x0E, 0); /* CR14 */
 
-	// Disable TX_IQUN
+	/* Disable TX_IQUN */
 	BBbReadEmbedded(pDevice->PortOffset, 0x09, &pDevice->byBBCR09);
 	BBbWriteEmbedded(pDevice->PortOffset, 0x09, (unsigned char)(pDevice->byBBCR09 & 0xDE));
 }
@@ -2367,21 +2367,21 @@ void BBvLoopbackOff(PSDevice pDevice)
 	unsigned char byData;
 	unsigned long dwIoBase = pDevice->PortOffset;
 
-	BBbWriteEmbedded(dwIoBase, 0xC9, pDevice->byBBCRc9);//CR201
-	BBbWriteEmbedded(dwIoBase, 0x88, pDevice->byBBCR88);//CR136
-	BBbWriteEmbedded(dwIoBase, 0x09, pDevice->byBBCR09);//CR136
-	BBbWriteEmbedded(dwIoBase, 0x4D, pDevice->byBBCR4d);//CR77
-
-	if (pDevice->uConnectionRate <= RATE_11M) { // CCK
-		// Set the CR33 Bit2 to disable internal Loopback.
-		BBbReadEmbedded(dwIoBase, 0x21, &byData);//CR33
-		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData & 0xFE));//CR33
-	} else { // OFDM
-		BBbReadEmbedded(dwIoBase, 0x9A, &byData);//CR154
-		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData & 0xFE));//CR154
+	BBbWriteEmbedded(dwIoBase, 0xC9, pDevice->byBBCRc9); /* CR201 */
+	BBbWriteEmbedded(dwIoBase, 0x88, pDevice->byBBCR88); /* CR136 */
+	BBbWriteEmbedded(dwIoBase, 0x09, pDevice->byBBCR09); /* CR136 */
+	BBbWriteEmbedded(dwIoBase, 0x4D, pDevice->byBBCR4d); /* CR77  */
+
+	if (pDevice->uConnectionRate <= RATE_11M) { /* CCK */
+		/* Set the CR33 Bit2 to disable internal Loopback. */
+		BBbReadEmbedded(dwIoBase, 0x21, &byData);/* CR33 */
+		BBbWriteEmbedded(dwIoBase, 0x21, (unsigned char)(byData & 0xFE)); /* CR33 */
+	} else { /* OFDM */
+		BBbReadEmbedded(dwIoBase, 0x9A, &byData); /* CR154 */
+		BBbWriteEmbedded(dwIoBase, 0x9A, (unsigned char)(byData & 0xFE)); /* CR154 */
 	}
-	BBbReadEmbedded(dwIoBase, 0x0E, &byData);//CR14
-	BBbWriteEmbedded(dwIoBase, 0x0E, (unsigned char)(byData | 0x80));//CR14
+	BBbReadEmbedded(dwIoBase, 0x0E, &byData); /* CR14 */
+	BBbWriteEmbedded(dwIoBase, 0x0E, (unsigned char)(byData | 0x80)); /* CR14 */
 }
 
 /*
@@ -2402,19 +2402,19 @@ BBvSetShortSlotTime(PSDevice pDevice)
 	unsigned char byBBRxConf = 0;
 	unsigned char byBBVGA = 0;
 
-	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
+	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
 
 	if (pDevice->bShortSlotTime)
-		byBBRxConf &= 0xDF;//1101 1111
+		byBBRxConf &= 0xDF; /* 1101 1111 */
 	else
-		byBBRxConf |= 0x20;//0010 0000
+		byBBRxConf |= 0x20; /* 0010 0000 */
 
-	// patch for 3253B0 Baseband with Cardbus module
+	/* patch for 3253B0 Baseband with Cardbus module */
 	BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byBBVGA);
 	if (byBBVGA == pDevice->abyBBVGA[0])
-		byBBRxConf |= 0x20;//0010 0000
+		byBBRxConf |= 0x20; /* 0010 0000 */
 
-	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
+	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf); /* CR10 */
 }
 
 void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
@@ -2423,16 +2423,16 @@ void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
 
 	BBbWriteEmbedded(pDevice->PortOffset, 0xE7, byData);
 
-	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf);//CR10
-	// patch for 3253B0 Baseband with Cardbus module
+	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
+	/* patch for 3253B0 Baseband with Cardbus module */
 	if (byData == pDevice->abyBBVGA[0])
-		byBBRxConf |= 0x20;//0010 0000
+		byBBRxConf |= 0x20; /* 0010 0000 */
 	else if (pDevice->bShortSlotTime)
-		byBBRxConf &= 0xDF;//1101 1111
+		byBBRxConf &= 0xDF; /* 1101 1111 */
 	else
-		byBBRxConf |= 0x20;//0010 0000
+		byBBRxConf |= 0x20; /* 0010 0000 */
 	pDevice->byBBVGACurrent = byData;
-	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf);//CR10
+	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf); /* CR10 */
 }
 
 /*
@@ -2519,18 +2519,18 @@ BBvSetTxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
 {
 	unsigned char byBBTxConf;
 
-	BBbReadEmbedded(dwIoBase, 0x09, &byBBTxConf);//CR09
+	BBbReadEmbedded(dwIoBase, 0x09, &byBBTxConf); /* CR09 */
 	if (byAntennaMode == ANT_DIVERSITY) {
-		// bit 1 is diversity
+		/* bit 1 is diversity */
 		byBBTxConf |= 0x02;
 	} else if (byAntennaMode == ANT_A) {
-		// bit 2 is ANTSEL
-		byBBTxConf &= 0xF9; // 1111 1001
+		/* bit 2 is ANTSEL */
+		byBBTxConf &= 0xF9; /* 1111 1001 */
 	} else if (byAntennaMode == ANT_B) {
-		byBBTxConf &= 0xFD; // 1111 1101
+		byBBTxConf &= 0xFD; /* 1111 1101 */
 		byBBTxConf |= 0x04;
 	}
-	BBbWriteEmbedded(dwIoBase, 0x09, byBBTxConf);//CR09
+	BBbWriteEmbedded(dwIoBase, 0x09, byBBTxConf); /* CR09 */
 }
 
 /*
@@ -2552,17 +2552,17 @@ BBvSetRxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
 {
 	unsigned char byBBRxConf;
 
-	BBbReadEmbedded(dwIoBase, 0x0A, &byBBRxConf);//CR10
+	BBbReadEmbedded(dwIoBase, 0x0A, &byBBRxConf); /* CR10 */
 	if (byAntennaMode == ANT_DIVERSITY) {
 		byBBRxConf |= 0x01;
 
 	} else if (byAntennaMode == ANT_A) {
-		byBBRxConf &= 0xFC; // 1111 1100
+		byBBRxConf &= 0xFC; /* 1111 1100 */
 	} else if (byAntennaMode == ANT_B) {
-		byBBRxConf &= 0xFE; // 1111 1110
+		byBBRxConf &= 0xFE; /* 1111 1110 */
 		byBBRxConf |= 0x02;
 	}
-	BBbWriteEmbedded(dwIoBase, 0x0A, byBBRxConf);//CR10
+	BBbWriteEmbedded(dwIoBase, 0x0A, byBBRxConf); /* CR10 */
 }
 
 /*
@@ -2580,15 +2580,15 @@ BBvSetRxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
 void
 BBvSetDeepSleep(unsigned long dwIoBase, unsigned char byLocalID)
 {
-	BBbWriteEmbedded(dwIoBase, 0x0C, 0x17);//CR12
-	BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9);//CR13
+	BBbWriteEmbedded(dwIoBase, 0x0C, 0x17); /* CR12 */
+	BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9); /* CR13 */
 }
 
 void
 BBvExitDeepSleep(unsigned long dwIoBase, unsigned char byLocalID)
 {
-	BBbWriteEmbedded(dwIoBase, 0x0C, 0x00);//CR12
-	BBbWriteEmbedded(dwIoBase, 0x0D, 0x01);//CR13
+	BBbWriteEmbedded(dwIoBase, 0x0C, 0x00); /* CR12 */
+	BBbWriteEmbedded(dwIoBase, 0x0D, 0x01); /* CR13 */
 }
 
 static
@@ -2599,7 +2599,7 @@ s_ulGetRatio(PSDevice pDevice)
 	unsigned long ulMaxPacket;
 	unsigned long ulPacketNum;
 
-	//This is a thousand-ratio
+	/* This is a thousand-ratio */
 	ulMaxPacket = pDevice->uNumSQ3[RATE_54M];
 	if (pDevice->uNumSQ3[RATE_54M] != 0) {
 		ulPacketNum = pDevice->uNumSQ3[RATE_54M];
@@ -2751,7 +2751,7 @@ BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ
 			BBvClearAntDivSQ3Value(pDevice);
 
 		}
-	} else { //byAntennaState == 1
+	} else { /* byAntennaState == 1 */
 
 		if (pDevice->uDiversityCnt > pDevice->ulDiversityMValue) {
 			del_timer(&pDevice->TimerSQ3Tmax1);
@@ -2775,7 +2775,7 @@ BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ
 			pDevice->byAntennaState = 0;
 			BBvClearAntDivSQ3Value(pDevice);
 		}
-	} //byAntennaState
+	} /* byAntennaState */
 }
 
 /*+
-- 
1.7.9.5

