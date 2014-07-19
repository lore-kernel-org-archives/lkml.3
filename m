Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaGSM4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 08:56:00 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:46907 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbaGSMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 08:55:57 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <eaf2dad9ae771c6780117ed315bd0e73>
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, thierry.reding@gmail.com, b.galvani@gmail.com
Cc: cf@rock-chips.com, huangtao@rock-chips.com, addy.ke@rock-chips.com,
        xjq@rock-chips.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v2 1/2] pwm: add this patch to introduce for rk-pwm and vop-pwm
Date: Sat, 19 Jul 2014 20:55:28 +0800
Message-Id: <1405774529-26027-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
index 3182126..bb6e7f1 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
@@ -1,11 +1,14 @@
 Rockchip PWM controller
 
 Required properties:
- - compatible: should be "rockchip,rk2928-pwm"
- - reg: physical base address and length of the controller's registers
- - clocks: phandle and clock specifier of the PWM reference clock
- - #pwm-cells: should be 2. See pwm.txt in this directory for a
-   description of the cell format.
+- compatible: should be "rockchip,<name>-pwm"should be one of following:
+    "rockchip,rk2928-pwm" - support the old version PWM for RK29xx,RK3066,RK3188 SoCs.
+    "rockchip,rk3288-pwm" - support the new version PWM for RK3036,RK3288 SoCs.
+    "rockchip,vop-pwm" - support rockchip integrated VOP-PWM for RK32 SoCs.
+- reg: physical base address and length of the controller's registers.
+- clocks: phandle and clock specifier of the PWM reference clock.
+- #pwm-cells: should be 2. See pwm.txt in this directory for a
+  description of the cell format.
 
 Example:
 
-- 
1.9.1


