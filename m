Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaJVNSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:18:10 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:34752 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177AbaJVNRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:17:51 -0400
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Alan Cox <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <yh.chen@mediatek.com>,
        <hc.yen@mediatek.com>, <nathan.chung@mediatek.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 3/3] DTS: serial: Add bindings document for the Mediatek UARTs
Date: Wed, 22 Oct 2014 21:12:09 +0800
Message-ID: <1413983529-21887-4-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
References: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add s devicetree document for Mediatek UART.

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 Documentation/devicetree/bindings/serial/mtk-uart.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
index 48358a3..0eebbfe 100644
--- a/Documentation/devicetree/bindings/serial/mtk-uart.txt
+++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
@@ -2,6 +2,8 @@
 
 Required properties:
 - compatible should contain:
+  * "mediatek,mt8135-uart" for MT8135 compatible UARTS
+  * "mediatek,mt8127-uart" for MT8127 compatible UARTS
   * "mediatek,mt6589-uart" for MT6589 compatible UARTS
   * "mediatek,mt6582-uart" for MT6582 compatible UARTS
   * "mediatek,mt6577-uart" for all compatible UARTS (MT6589, MT6582, MT6577)
-- 
1.8.1.1.dirty

