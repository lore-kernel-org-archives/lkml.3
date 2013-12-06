Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3LFUsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:48:36 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55214 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757977Ab3LFUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:48:33 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: dts: mxs: Add iio-hwmon to crystalfontz boards
Date: Fri,  6 Dec 2013 21:47:23 +0100
Message-Id: <1386362843-20798-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

This won't work until those patches are applied:
 https://lkml.org/lkml/2013/12/6/676
 and http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/216963.html

However, I'm wondering if it wouldn't make sense to add it directly in
imx28.dtsi

 arch/arm/boot/dts/imx28-cfa10036.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index cabb6171a19d..51ebf36dd7b9 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -114,4 +114,9 @@
 			default-state = "on";
 		};
 	};
+
+	iio_hwmon {
+		compatible = "iio-hwmon";
+		io-channels = <&lradc 8>;
+	};
 };
-- 
1.8.3.2

