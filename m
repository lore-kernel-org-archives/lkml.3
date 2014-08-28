Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaH1BAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:00:46 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:36500 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbaH1BAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:00:23 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <064ca85fc15633810925ac9b4cd52f7a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v4 4/4] ARM: dts: enable Thermal on rk3288-evb board
Date: Thu, 28 Aug 2014 08:59:22 +0800
Message-Id: <1409187562-12370-5-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 2964370..fe85dde 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -101,6 +101,13 @@
 	status = "okay";
 };
 
+&tsadc {
+	passive-temp = <80>;
+	critical-temp = <100>;
+	force-shut-temp = <120>;
+	status = "okay";
+};
+
 &pinctrl {
 	buttons {
 		pwrbtn: pwrbtn {
-- 
1.9.1


