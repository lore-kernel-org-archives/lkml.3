Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbbASMaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:30:35 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58553 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbASMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:30:34 -0500
Date: Mon, 19 Jan 2015 14:30:25 +0200
From: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        guido@vanguardiasur.com.ar, silvagustavosilva@gmail.com,
        gclement@baobob.org, joe@perches.com, linux-kernel@vger.kernel.org,
        fred.chou.nd@gmail.com
Subject: [PATCH] staging: vt6655: mac.h: fix space prohibited before that ','
Message-ID: <20150119123025.GA24976@lotfy1893-Ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix space prohibited before that ','

Signed-off-by: Mohamed Lotfy Hammad <mohamed.lotfy.hammad@gmail.com>
---
 drivers/staging/vt6655/mac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index e1e7e10..4985c63 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -888,7 +888,7 @@ do {									\
 	VNSvOutPortB(dwIoBase + MAC_REG_PAGE1SEL, 1)
 
 #define MACvReadMIBCounter(dwIoBase, pdwCounter)			\
-	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR , pdwCounter)
+	VNSvInPortD(dwIoBase + MAC_REG_MIBCNTR, pdwCounter)
 
 #define MACvPwrEvntDisable(dwIoBase)					\
 	VNSvOutPortW(dwIoBase + MAC_REG_WAKEUPEN0, 0x0000)
-- 
2.1.0

