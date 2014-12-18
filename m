Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaLRIeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:34:01 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:59628 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbaLRId7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:33:59 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Alan Cox <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <yingjoe.chen@mediatek.com>, <yh.chen@mediatek.com>
Subject: [PATCH 2/2] arm64: dts: Add mediatek MT8173 earlycon support
Date: Thu, 18 Dec 2014 16:33:21 +0800
Message-ID: <1418891601-53769-3-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com>
References: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add earlycon support to mediatek MT8173 evaluation board dts.

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 arch/arm64/boot/dts/mt8173-evb.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mt8173-evb.dts b/arch/arm64/boot/dts/mt8173-evb.dts
index b8b2621..b8802fd 100644
--- a/arch/arm64/boot/dts/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mt8173-evb.dts
@@ -30,5 +30,7 @@
 		reg = <0 0x40000000 0 0x80000000>;
 	};
 
-	chosen { };
+	chosen {
+		linux,stdout-path = &uart0;
+	};
 };
-- 
1.8.1.1.dirty

