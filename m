Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaBJTrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:47:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaBJTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Guinot <simon.guinot@sequanux.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 068/124] ARM: mvebu: update the SATA compatible string for Armada 370/XP
Date: Mon, 10 Feb 2014 11:40:08 -0800
Message-Id: <1392061264-28124-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <simon.guinot@sequanux.org>

commit a96cc303e42ad7830dde929aad0046e448a05505 upstream.

This patch updates the Armada 370/XP SATA node with the new compatible
string "marvell,armada-370-sata".

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Lior Amsalem <alior@marvell.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/boot/dts/armada-370-xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index eadd0bf..146c850 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -79,7 +79,7 @@
 		};
 
 		sata@d00a0000 {
-			compatible = "marvell,orion-sata";
+			compatible = "marvell,armada-370-sata";
 			reg = <0xd00a0000 0x5000>;
 			interrupts = <55>;
 			clocks = <&gateclk 15>, <&gateclk 30>;
-- 
1.8.3.2

