Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab3E2Ngc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:36:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61490 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935172Ab3E2Ng2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:36:28 -0400
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 3/4] ARM: u8540: Add device tree support for bh1780
Date: Wed, 29 May 2013 15:33:26 +0200
Message-Id: <1369834407-30762-4-git-send-email-gabriel.fernandez.st@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
References: <1369834407-30762-1-git-send-email-gabriel.fernandez.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@st.com>

This patch adds DT probing of the light sensor bh1780
for u8540.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/ccu8540-uib-v3.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/ccu8540-uib-v3.dts b/arch/arm/boot/dts/ccu8540-uib-v3.dts
index 422a292..dc90571 100644
--- a/arch/arm/boot/dts/ccu8540-uib-v3.dts
+++ b/arch/arm/boot/dts/ccu8540-uib-v3.dts
@@ -16,6 +16,11 @@
 };
 
 &i2c2 {
+	bh1780@29 {
+		compatible = "bh1780";
+		reg = <0x29>;
+		vcc-supply = <&ab8500_ldo_aux1_reg>;
+	};
 
 	lp5521@32 {
 		compatible = "national,lp5521";
-- 
1.8.1.1

