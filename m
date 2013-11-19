Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3KSLLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:11:39 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61334 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3KSLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:08:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 01/10] dma: ste_dma40: Expand DT binding to accept 'high-priority channel' flag
Date: Tue, 19 Nov 2013 11:07:40 +0000
Message-Id: <1384859269-19801-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used for MSP (audio) devices which is about to be fully DT:ed.

Cc: devicetree@vger.kernel.org
Acked-by: Vinod Koul <vinod.koul@intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/dma/ste-dma40.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
index a8c21c2..1f5729f 100644
--- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -50,6 +50,9 @@ Each dmas request consists of 4 cells:
         0x00000008: Use fixed channel:
                 Use automatic channel selection when unset
                 Use DMA request line number when set
+        0x00000010: Set channel as high priority:
+                Normal priority when unset
+                High priority when set
 
 Example:
 
-- 
1.8.1.2

