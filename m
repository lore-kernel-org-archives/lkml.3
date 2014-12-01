Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaLAHif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:38:35 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:44899 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaLAHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:38:33 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <6e9647e25895a7f3b0b9ee488a9e44a0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, linux@arm.linux.org.uk, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH 1/2] rockchip: efuse: add documentation for rk3288 efuse driver
Date: Mon,  1 Dec 2014 15:34:40 +0800
Message-Id: <1417419281-9243-2-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
References: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RK3288, there are two eFuse. One is organized as 32bits by 8 one-time programmable
electrical fuses with random access interface, and the other is organized as 32bits by 32
one-time programmable electrical fuses.
The 32x32 eFuse can only be accessed by APB bus when IO_SECURITYsel is high.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 .../devicetree/bindings/fuse/rockchip,rk3288-efuse.txt     | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/fuse/rockchip,rk3288-efuse.txt

diff --git a/Documentation/devicetree/bindings/fuse/rockchip,rk3288-efuse.txt b/Documentation/devicetree/bindings/fuse/rockchip,rk3288-efuse.txt
new file mode 100644
index 0000000..82af730
--- /dev/null
+++ b/Documentation/devicetree/bindings/fuse/rockchip,rk3288-efuse.txt
@@ -0,0 +1,14 @@
+ROCKCHIP RK3288 efuse block.
+
+Required properties:
+- compatible : should be:
+	"rockchip,rk3288-efuse"
+- reg: Should contain 1 entry: the entry gives the physical address and length
+       of the fuse registers.
+
+Example:
+
+	efuse: efuse@ffb40000 {
+		compatible = "rockchip,rk3288-efuse";
+		reg = <0xffb40000 0x10000>;
+	};
-- 
1.9.1


