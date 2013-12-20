Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3LTKhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:37:35 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36120 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab3LTKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:37:32 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 05:37:32 EST
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de
Subject: [PATCH 1/3] rtl8192e: Fixing checkpatch errors
Date: Fri, 20 Dec 2013 11:29:08 +0100
Message-Id: <1387535350-27442-2-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch errors from rtllib_endianfree.h:
 - ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
---
 drivers/staging/rtl8192e/rtllib_endianfree.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_endianfree.h b/drivers/staging/rtl8192e/rtllib_endianfree.h
index b268605..39b8204 100644
--- a/drivers/staging/rtl8192e/rtllib_endianfree.h
+++ b/drivers/staging/rtl8192e/rtllib_endianfree.h
@@ -33,9 +33,9 @@
 #define ReadEF2Byte(_ptr)		EF2Byte(*((u16 *)(_ptr)))
 #define ReadEF4Byte(_ptr)		EF4Byte(*((u32 *)(_ptr)))
 
-#define WriteEF1Byte(_ptr, _val)	(*((u8 *)(_ptr))) = EF1Byte(_val)
-#define WriteEF2Byte(_ptr, _val)	(*((u16 *)(_ptr))) = EF2Byte(_val)
-#define WriteEF4Byte(_ptr, _val)	(*((u32 *)(_ptr))) = EF4Byte(_val)
+#define WriteEF1Byte(_ptr, _val)	((*((u8 *)(_ptr))) = EF1Byte(_val))
+#define WriteEF2Byte(_ptr, _val)	((*((u16 *)(_ptr))) = EF2Byte(_val))
+#define WriteEF4Byte(_ptr, _val)	((*((u32 *)(_ptr))) = EF4Byte(_val))
 #if BYTE_ORDER == __MACHINE_LITTLE_ENDIAN
 #define H2N1BYTE(_val)	((u8)(_val))
 #define H2N2BYTE(_val)	(((((u16)(_val))&0x00ff)<<8)|\
-- 
1.8.1.2

