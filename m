Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaKLQIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:08:51 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44379 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbaKLQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:08:49 -0500
From: Howard Chen <ibanezchen@gmail.com>
To: arm@kernel.org, Matthias Brugger <matthias.bgg@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Howard Chen <ibanezchen@gmail.com>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 4/4] DTS: serial: Add bindings documention for the Mediatek UARTs
Date: Thu, 13 Nov 2014 00:07:37 +0800
Message-Id: <1415808457-4030-4-git-send-email-ibanezchen@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415808457-4030-1-git-send-email-ibanezchen@gmail.com>
References: <1415808457-4030-1-git-send-email-ibanezchen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add s devicetree document for Mediatek UART.

Signed-off-by: Howard Chen <ibanezchen@gmail.com>
---
 Documentation/devicetree/bindings/serial/mtk-uart.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
index 48358a3..e2864b7 100644
--- a/Documentation/devicetree/bindings/serial/mtk-uart.txt
+++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
@@ -2,9 +2,10 @@
 
 Required properties:
 - compatible should contain:
+  * "mediatek,mt6592-uart" for MT6592 compatible UARTS
   * "mediatek,mt6589-uart" for MT6589 compatible UARTS
   * "mediatek,mt6582-uart" for MT6582 compatible UARTS
-  * "mediatek,mt6577-uart" for all compatible UARTS (MT6589, MT6582, MT6577)
+  * "mediatek,mt6577-uart" for all compatible UARTS on MT65xx
 
 - reg: The base address of the UART register bank.
 
-- 
1.9.1

