Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaFET2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:28:11 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:50163 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbaFET2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:28:06 -0400
X-Sasl-enc: goAVa69VkPA9+o6yWQOEq2DDtJPYayQN4NJ3n0hXmSzr 1401996481
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        rdunlap@infradead.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH 4/6] arm: pxa2xx.dtsi: disable RTC by default
Date: Thu,  5 Jun 2014 14:27:06 -0500
Message-Id: <5a807a8d36ef3313b0d48a2fe88720f1fe246d7f.1401995177.git.andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
In-Reply-To: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
References: <cover.1401995177.git.andrew.ruder@elecsyscorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sets the status="disabled" flag in pxa2xx.dtsi in the same style as
the other optional components.  This can be overridden on a case-by-case
basis by boards that use this functionality.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 arch/arm/boot/dts/pxa2xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/pxa2xx.dtsi b/arch/arm/boot/dts/pxa2xx.dtsi
index c08f846..d233088 100644
--- a/arch/arm/boot/dts/pxa2xx.dtsi
+++ b/arch/arm/boot/dts/pxa2xx.dtsi
@@ -130,6 +130,7 @@
 			compatible = "marvell,pxa-rtc";
 			reg = <0x40900000 0x3c>;
 			interrupts = <30 31>;
+			status = "disabled";
 		};
 	};
 };
-- 
1.9.0.rc3.12.gbc97e2d

