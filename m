Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbAFImP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:42:15 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63634 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbbAFImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:42:12 -0500
From: Howard Chen <howard.chen@linaro.org>
To: matthias.bgg@gmail.com
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Jason Cooper <jason@lakedaemon.net>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek
	SoC...)
Subject: [PATCH 2/2] dt-bindings: add mt6592 compatible string for mediatek sysirq
Date: Tue,  6 Jan 2015 16:42:31 +0800
Message-Id: <1420533751-23999-2-git-send-email-howard.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420533751-23999-1-git-send-email-howard.chen@linaro.org>
References: <1420533751-23999-1-git-send-email-howard.chen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Howard Chen <howard.chen@linaro.org>
---
 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
index d680b07..4cd6f7b 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
@@ -7,6 +7,7 @@ Required properties:
 - compatible: should be one of:
 	"mediatek,mt8135-sysirq"
 	"mediatek,mt8127-sysirq"
+	"mediatek,mt6592-sysirq"
 	"mediatek,mt6589-sysirq"
 	"mediatek,mt6582-sysirq"
 	"mediatek,mt6577-sysirq"
-- 
1.9.1

