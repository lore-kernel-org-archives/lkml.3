Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3HGBdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 21:33:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3HGBdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 21:33:31 -0400
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, sboyd@codeaurora.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] ARM: dts: Fix memory node in skeleton64.dtsi
Date: Tue,  6 Aug 2013 18:33:06 -0700
Message-Id: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the reg property of the memory node in
skeleton64.dtsi to reflect the fact that the root node uses
address-cells=2 and size-cells=2.

Change-Id: Ie9b61166143969e020ceebc51e9a384405d8c0f2
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/boot/dts/skeleton64.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/skeleton64.dtsi b/arch/arm/boot/dts/skeleton64.dtsi
index 1599415..b5d7f36 100644
--- a/arch/arm/boot/dts/skeleton64.dtsi
+++ b/arch/arm/boot/dts/skeleton64.dtsi
@@ -9,5 +9,5 @@
 	#size-cells = <2>;
 	chosen { };
 	aliases { };
-	memory { device_type = "memory"; reg = <0 0>; };
+	memory { device_type = "memory"; reg = <0 0 0 0>; };
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

