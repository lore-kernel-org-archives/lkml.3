Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaKHR1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:27:12 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37362 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaKHR1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:27:10 -0500
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: devicetree@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        opw-kernel@googlegroups.com,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v5 4/4] arch: arm: boot: dts: Correct vendor-prefix for iio device isl29028 in compatible property
Date: Sat,  8 Nov 2014 22:52:08 +0530
Message-Id: <1415467328-9745-5-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
References: <1415467328-9745-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the vendor-prefix for isl29028 in the compatible property from
"isil,isl29028" to "isl,isl29028" according to listed vendor-prefixes in
Documentation/devicetree/bindings/vendor-prefixes.txt. Incorrect vendor-prefix "isl"
was reported by checkpatch.pl warning for drivers/staging/iio/light/isl29028.c.
Thus incorrect vendor-prefix "isil" was corrected for every mention of device isl29028.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
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

