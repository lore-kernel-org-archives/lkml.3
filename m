Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaJGPUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:20:03 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65457 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaJGPT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:59 -0400
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: opw-kernel@googlegroups.com
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v4 4/4] arch: arm: boot: dts: Added correct vendor-prefix with device name to compatible property
Date: Tue,  7 Oct 2014 20:49:29 +0530
Message-Id: <1412695169-22815-5-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the correct vendor-prefix listed in Documentation/devicetree/bindings/vendor-prefixes.txt
with the device name to compatible property.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 2063795..dcc6c75 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -187,7 +187,7 @@
 
 		/* ALS and Proximity sensor */
 		isl29028@44 {
-			compatible = "isil,isl29028";
+			compatible = "isl,isl29028";
 			reg = <0x44>;
 			interrupt-parent = <&gpio>;
 			interrupts = <TEGRA_GPIO(L, 0) IRQ_TYPE_LEVEL_HIGH>;
-- 
1.9.1

