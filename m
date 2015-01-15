Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbbAOQcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:32:14 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:35230 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbbAOQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:32:10 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:35 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Staging: vt6655: Checkpatch fix: lines longer than 80 columns
Date: Fri, 16 Jan 2015 03:29:25 +1100
Message-Id: <1421339367-23521-6-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
References: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl errors in mac.h:
WARNING: line over 80 characters

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6655/mac.h | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index fcd1f3c..d1a56cb 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -953,15 +953,18 @@ do {								\
 #define MACvSetRFLE_LatchBase(dwIoBase)                                 \
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_RFLEOPT)
 
-bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
-bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
+bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs,
+		     unsigned char byTestBits);
+bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs,
+		      unsigned char byTestBits);
 
 bool MACbIsIntDisable(void __iomem *dwIoBase);
 
 void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
 
 void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
-void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit);
+void MACvGetLongRetryLimit(void __iomem *dwIoBase,
+			   unsigned char *pbyRetryLimit);
 
 void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode);
 
@@ -975,22 +978,32 @@ bool MACbSafeTxOff(void __iomem *dwIoBase);
 bool MACbSafeStop(void __iomem *dwIoBase);
 bool MACbShutdown(void __iomem *dwIoBase);
 void MACvInitialize(void __iomem *dwIoBase);
-void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrSyncDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrATIMDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase,
+			    unsigned long dwCurrDescAddr);
+void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase,
+			    unsigned long dwCurrDescAddr);
+void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase,
+			   unsigned long dwCurrDescAddr);
+void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase,
+			      unsigned long dwCurrDescAddr);
+void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase,
+			      unsigned long dwCurrDescAddr);
+void MACvSetCurrSyncDescAddrEx(void __iomem *dwIoBase,
+			       unsigned long dwCurrDescAddr);
+void MACvSetCurrATIMDescAddrEx(void __iomem *dwIoBase,
+			       unsigned long dwCurrDescAddr);
 void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay);
 void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
 
-void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset, unsigned long dwData);
+void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset,
+		     unsigned long dwData);
 
 bool MACbPSWakeup(void __iomem *dwIoBase);
 
-void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
-		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID);
+void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl,
+		     unsigned int uEntryIdx, unsigned int uKeyIdx,
+		     unsigned char *pbyAddr, u32 *pdwKey,
+		     unsigned char byLocalID);
 void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx);
 
 #endif /* __MAC_H__ */
-- 
2.2.1

