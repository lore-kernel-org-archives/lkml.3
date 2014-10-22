Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaJVS1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:27:54 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36760 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJVS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:27:06 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] ARM: berlin: Add phy-connection-type to BG2Q Ethernet
Date: Wed, 22 Oct 2014 20:26:51 +0200
Message-Id: <1414002412-13615-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Ténart <antoine.tenart@free-electrons.com>

Internal FastEthernet PHY on BG2Q is connected via MII, add a
corresponding phy-connection-type property to the Ethernet node.

Tested-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- add phy-connection-type to controller node instead of PHY node
  (Reported by Sergei Shtylyov)

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2q.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 891d56b03922..6bd01add3984 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -123,6 +123,7 @@
 			local-mac-address = [00 00 00 00 00 00];
 			#address-cells = <1>;
 			#size-cells = <0>;
+			phy-connection-type = "mii";
 			phy-handle = <&ethphy0>;
 			status = "disabled";
 
-- 
2.1.1

