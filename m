Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3ARVa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:30:59 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:47101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3ARVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:30:57 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ARM: sunxi: olinuxino: Add muxing for the uart
Date: Fri, 18 Jan 2013 22:30:39 +0100
Message-Id: <1358544639-14761-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
index 498a091..4a1e45d 100644
--- a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
+++ b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
@@ -24,6 +24,8 @@
 
 	soc {
 		uart1: uart@01c28400 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart1_pins_b>;
 			status = "okay";
 		};
 	};
-- 
1.7.10.4

