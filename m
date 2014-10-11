Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaJKH3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 03:29:55 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:60536 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaJKH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 03:29:51 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <c30ae2d0a633c6ac8900ea08ecd2b34b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v9 5/5] ARM: dts: enable Thermal on rk3288-evb board
Date: Sat, 11 Oct 2014 15:29:23 +0800
Message-Id: <1413012563-7690-6-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
References: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when a thermal temperature over TSHUT.Default to via
CRU reset the entire chip on rk3288-evb Board

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 2964370..d257cd8 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -101,6 +101,11 @@
 	status = "okay";
 };
 
+&tsadc {
+	tsadc-ht-reset-mode = <0>; /* reset mode 0:CRU 1:GPIO */
+	status = "okay";
+};
+
 &pinctrl {
 	buttons {
 		pwrbtn: pwrbtn {
-- 
1.9.1


