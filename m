Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaJUJZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:25:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42908 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaJUJW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 12/12] ARM: dts: berlin: Enable eMMC on Sony NSZ-GS7
Date: Tue, 21 Oct 2014 11:22:44 +0200
Message-Id: <1413883364-681-13-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SDHCI for BG2, we can now enable the port and allow to access
Samsung M8G2FA 8GB eMMC on Sony NSZ-GS7.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts b/arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
index c72bfd468d10..5e5f3a90e465 100644
--- a/arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
+++ b/arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts
@@ -26,4 +26,11 @@
 	};
 };
 
+/* Samsung M8G2FA 8GB eMMC */
+&sdhci2 {
+	non-removable;
+	bus-width = <8>;
+	status = "okay";
+};
+
 &uart0 { status = "okay"; };
-- 
2.1.1

