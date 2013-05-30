Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3E3N2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:28:48 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54044 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3E3N2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:22 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/5] ARM: ux500: Add DT regulators for ab8500-codec
Date: Thu, 30 May 2013 15:27:43 +0200
Message-Id: <1369920465-13905-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add regulator DT bindings for the ab8500-codec driver.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index d0b6e32..8e14042 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -410,6 +410,11 @@
 				codec: ab8500-codec {
 					compatible = "stericsson,ab8500-codec";
 
+					V-AUD-supply = <&ab8500_ldo_audio_reg>;
+					V-AMIC1-supply = <&ab8500_ldo_anamic1_reg>;
+					V-AMIC2-supply = <&ab8500_ldo_anamic2_reg>;
+					V-DMIC-supply = <&ab8500_ldo_dmic_reg>;
+
 					stericsson,earpeice-cmv = <950>; /* Units in mV. */
 				};
 
-- 
1.8.2

