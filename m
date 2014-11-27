Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaK0Rqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:46:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44212 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0Rqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:46:48 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: grant.likely@linaro.org
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] m32r: Fix ioread8 definition
Date: Thu, 27 Nov 2014 09:46:43 -0800
Message-Id: <1417110404-13297-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be readb(), not read().

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/m32r/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1f..343ae4c 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -162,7 +162,7 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define __raw_writew writew
 #define __raw_writel writel
 
-#define ioread8 read
+#define ioread8 readb
 #define ioread16 readw
 #define ioread32 readl
 #define iowrite8 writeb
-- 
2.1.0

