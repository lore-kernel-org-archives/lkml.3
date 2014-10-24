Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaJXFhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:37:16 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:43724 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482AbaJXFhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:37:13 -0400
X-Listener-Flag: 11101
Subject: [PATCH v4 8/8] ARM: mediatek: Fix description for mediatek SoCs
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, <arm@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        huang eddie <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Yuhau Chen <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
In-Reply-To: <CABuKBeLJuaDnCYuvvS6csNzvbTeEdgEUdZ4tBQeVPuw37JK11Q@mail.gmail.com>
References: <1413973797-17619-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1413973797-17619-9-git-send-email-yingjoe.chen@mediatek.com>
	 <CABuKBe+Ew6R2Kb90-gDHBQ4HuydfFxJdYmr+v9-KNC-b0K4Tkw@mail.gmail.com>
	 <1413984696.19686.72.camel@mtksdaap41>
	 <CABuKBeLJuaDnCYuvvS6csNzvbTeEdgEUdZ4tBQeVPuw37JK11Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Oct 2014 13:37:06 +0800
Message-ID: <1414129026.14830.588.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joe.C" <yingjoe.chen@mediatek.com>

We support more MediaTek SoCs now, update the description.

Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
---
 arch/arm/mach-mediatek/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mediatek/Kconfig
b/arch/arm/mach-mediatek/Kconfig
index 2c043a2..f73f588 100644
--- a/arch/arm/mach-mediatek/Kconfig
+++ b/arch/arm/mach-mediatek/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_MEDIATEK
-	bool "Mediatek MT6589 SoC" if ARCH_MULTI_V7
+	bool "Mediatek MT65xx & MT81xx SoC" if ARCH_MULTI_V7
 	select ARM_GIC
 	select MTK_TIMER
 	help
-	  Support for Mediatek Cortex-A7 Quad-Core-SoC MT6589.
+	  Support for Mediatek MT65xx & MT81xx SoCs
-- 
1.8.1.1.dirty



