Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423351Ab3FUQZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:25:19 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:51855 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422679Ab3FUQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:25:17 -0400
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: shawn.guo@linaro.org, gwenhael.goavec-merou@armadeus.com,
        linux@arm.linux.org.uk, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH] apf27dev: add rtc ds1374 to the device tree
Date: Fri, 21 Jun 2013 18:24:13 +0200
Message-Id: <1371831853-24754-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 arch/arm/boot/dts/imx27-apf27dev.dts |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index 66b8e1c..2a377ca 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -53,6 +53,11 @@
 &i2c1 {
 	clock-frequency = <400000>;
 	status = "okay";
+
+	rtc@68 {
+		compatible = "dallas,ds1374";
+		reg = <0x68>;
+	};
 };
 
 &i2c2 {
-- 
1.7.4.4

