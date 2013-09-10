Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3IJMt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:49:56 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50685 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3IJMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/38] ARM: ux500: Enable the LSM303DLH Accelerator sensor from DT
Date: Tue, 10 Sep 2013 13:49:04 +0100
Message-Id: <1378817379-8238-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying this node the LSM303DLH sensor chip should probe
successfully once the driver support has also been applied.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/ste-snowball.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index d355d25..d1f4c60 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -161,6 +161,14 @@
 				vdd-supply = <&ab8500_ldo_aux1_reg>;
 				vddio-supply = <&db8500_vsmps2_reg>;
 			};
+
+			lsm303dlh_accel@19 {
+				compatible = "st,lsm303dlh_accel";
+				reg = <0x19>;
+
+				vdd-supply = <&ab8500_ldo_aux1_reg>;
+				vddio-supply = <&db8500_vsmps2_reg>;
+			};
 		};
 
 		uart@80120000 {
-- 
1.8.1.2

