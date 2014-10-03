Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaJCP4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:56:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57998 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbaJCP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:56:00 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] ARM: dts: berlin: Enable WiFi on Google Chromecast
Date: Fri,  3 Oct 2014 17:55:46 +0200
Message-Id: <1412351747-4188-12-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SDHCI for BG2CD, we can now enable the port and allow to access
AzureWave WiFi/BT module on Google Chromecast.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
index 0816890a5c0d..bdcaff7c321e 100644
--- a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
+++ b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
@@ -43,4 +43,13 @@
 	};
 };
 
+/*
+ * AzureWave AW-NH387 (Marvell 88W8787)
+ * 802.11b/g/n + Bluetooth 2.1
+ */
+&sdhci0 {
+	non-removable;
+	status = "okay";
+};
+
 &uart0 { status = "okay"; };
-- 
2.1.1

