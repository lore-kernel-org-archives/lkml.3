Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161945AbaKNV30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:29:26 -0500
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:38360 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754335AbaKNV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:29:24 -0500
X-Greylist: delayed 8398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 16:29:24 EST
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] ARM: dts: rockchip: enable PWM on Radxa Rock
Date: Fri, 14 Nov 2014 16:32:25 +0100
Message-Id: <1415979145-19471-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 2350597532593357025
X-Ovh-Remote: 193.248.240.88 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrjeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrjeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables user space access to the 3 PWM available on the Radxa Rock headers.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 0950a05..6eb62c0 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -243,6 +243,18 @@
 	disable-wp;
 };
 
+&pwm1 {
+	status = "okay";
+};
+
+&pwm2 {
+	status = "okay";
+};
+
+&pwm3 {
+	status = "okay";
+};
+
 &pinctrl {
 	pcfg_output_low: pcfg-output-low {
 		output-low;
-- 
2.1.0

