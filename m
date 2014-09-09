Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaIIOry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:47:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58232 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932494AbaIIOrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:47:52 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: berlin: enable timer 1 for sched_clock
Date: Tue,  9 Sep 2014 16:47:49 +0200
Message-Id: <1410274069-24922-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable timer 1 to be the source for the sched_clock, allowing to have a
more precise value than 1/HZ.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index a216cb621ebc..e22b99a3a796 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -247,7 +247,6 @@
 				reg = <0x2c14 0x14>;
 				clocks = <&chip CLKID_CFG>;
 				clock-names = "timer";
-				status = "disabled";
 			};
 
 			timer2: timer@2c28 {
-- 
1.9.1

