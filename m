Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbaHHHby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:31:54 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:60194 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaHHHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:31:51 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: thierry.reding@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <1f8eefed39c1ddf089c13ebf804e13e7>
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: thierry.reding@gmail.com, heiko@sntech.de, b.galvani@gmail.com,
        robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, dianders@chromium.org
Cc: cf@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        xjq@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v5 1/2] pwm: rockchip: document RK3288 SoC compatible
Date: Fri,  8 Aug 2014 15:28:48 +0800
Message-Id: <1407482929-13050-2-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407482929-13050-1-git-send-email-caesar.wang@rock-chips.com>
References: <1407482929-13050-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new compatible for PWM founding on RK3288 SoC

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
index 3182126..d47d15a 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
@@ -1,7 +1,10 @@
 Rockchip PWM controller
 
 Required properties:
- - compatible: should be "rockchip,rk2928-pwm"
+ - compatible: should be "rockchip,<name>-pwm"
+   "rockchip,rk2928-pwm": found on RK29XX,RK3066 and RK3188 SoCs
+   "rockchip,rk3288-pwm": found on RK3288 SoC
+   "rockchip,vop-pwm": found integrated in VOP on RK3288 SoC
  - reg: physical base address and length of the controller's registers
  - clocks: phandle and clock specifier of the PWM reference clock
  - #pwm-cells: should be 2. See pwm.txt in this directory for a
-- 
1.9.1


