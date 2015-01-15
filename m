Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbbAOQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:31:57 -0500
Received: from mail14.tpgi.com.au ([203.12.160.182]:34979 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbAOQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:31:56 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Fri, 16 Jan 2015 03:31:28 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org,
        emrys@paradise.net.nz, tvboxspy@gmail.com, gclement@baobob.org,
        guido@vanguardiasur.com.ar
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Staging: vt6655: Checkpatch fix: unnecessary whitespace
Date: Fri, 16 Jan 2015 03:29:21 +1100
Message-Id: <1421339367-23521-2-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
References: <1421339367-23521-1-git-send-email-emrys@paradise.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl errors in mac.h:
ERROR: space prohibited before that ',' (ctx:WxW)

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6655/mac.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index e1e7e10..0f1d4a5 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -888,7 +888,7 @@ do {									\
 	VNSvOutPortB(dwIoBase + MAC_REG_PAGE1SEL, 1)
 
 #define MACvReadMIBCounter(dwIoBase, pdwCounter)			\
-	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR , pdwCounter)
+	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR, pdwCounter)
 
 #define MACvPwrEvntDisable(dwIoBase)					\
 	VNSvOutPortW(dwIoBase + MAC_REG_WAKEUPEN0, 0x0000)
@@ -896,7 +896,7 @@ do {									\
 #define MACvEnableProtectMD(dwIoBase)					\
 do {									\
 	unsigned long dwOrgValue;					\
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);		\
+	VNSvInPortD(dwIoBase + MAC_REG_ENCFG, &dwOrgValue);		\
 	dwOrgValue = dwOrgValue | EnCFG_ProtectMd;			\
 	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);		\
 } while (0)
@@ -904,7 +904,7 @@ do {									\
 #define MACvDisableProtectMD(dwIoBase)					\
 do {									\
 	unsigned long dwOrgValue;					\
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);		\
+	VNSvInPortD(dwIoBase + MAC_REG_ENCFG, &dwOrgValue);		\
 	dwOrgValue = dwOrgValue & ~EnCFG_ProtectMd;			\
 	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);		\
 } while (0)
@@ -912,7 +912,7 @@ do {									\
 #define MACvEnableBarkerPreambleMd(dwIoBase)				\
 do {									\
 	unsigned long dwOrgValue;					\
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);		\
+	VNSvInPortD(dwIoBase + MAC_REG_ENCFG, &dwOrgValue);		\
 	dwOrgValue = dwOrgValue | EnCFG_BarkerPream;			\
 	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);		\
 } while (0)
@@ -920,7 +920,7 @@ do {									\
 #define MACvDisableBarkerPreambleMd(dwIoBase)				\
 do {									\
 	unsigned long dwOrgValue;					\
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);		\
+	VNSvInPortD(dwIoBase + MAC_REG_ENCFG, &dwOrgValue);		\
 	dwOrgValue = dwOrgValue & ~EnCFG_BarkerPream;			\
 	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);		\
 } while (0)
@@ -928,7 +928,7 @@ do {									\
 #define MACvSetBBType(dwIoBase, byTyp)					\
 do {									\
 	unsigned long dwOrgValue;					\
-	VNSvInPortD(dwIoBase + MAC_REG_ENCFG , &dwOrgValue);		\
+	VNSvInPortD(dwIoBase + MAC_REG_ENCFG, &dwOrgValue);		\
 	dwOrgValue = dwOrgValue & ~EnCFG_BBType_MASK;			\
 	dwOrgValue = dwOrgValue | (unsigned long)byTyp;			\
 	VNSvOutPortD(dwIoBase + MAC_REG_ENCFG, dwOrgValue);		\
-- 
2.2.1

