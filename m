Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbbAHGWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 01:22:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36719 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbbAHGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 01:22:47 -0500
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
Date: Thu,  8 Jan 2015 14:23:11 +0800
Message-Id: <1420698191-10878-2-git-send-email-howard.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420698191-10878-1-git-send-email-howard.chen@linaro.org>
References: <1420698191-10878-1-git-send-email-howard.chen@linaro.org>
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

