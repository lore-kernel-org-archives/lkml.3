Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaAKTnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:43:35 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64500 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaAKTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:25 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH RFC 08/10] ARM: dts: s3c64xx: Add nodes for power domains
Date: Sat, 11 Jan 2014 20:42:50 +0100
Message-Id: <1389469372-17199-9-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree nodes for power domains available on S3C64xx
SoCs.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/s3c6400.dtsi | 1 +
 arch/arm/boot/dts/s3c6410.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/s3c6400.dtsi b/arch/arm/boot/dts/s3c6400.dtsi
index a7d1c8e..c1abdaf 100644
--- a/arch/arm/boot/dts/s3c6400.dtsi
+++ b/arch/arm/boot/dts/s3c6400.dtsi
@@ -37,5 +37,6 @@
 		compatible = "samsung,s3c6400-clock";
 		reg = <0x7e00f000 0x1000>;
 		#clock-cells = <1>;
+		#power-domain-cells = <1>;
 	};
 };
diff --git a/arch/arm/boot/dts/s3c6410.dtsi b/arch/arm/boot/dts/s3c6410.dtsi
index eb4226b..7e48c86 100644
--- a/arch/arm/boot/dts/s3c6410.dtsi
+++ b/arch/arm/boot/dts/s3c6410.dtsi
@@ -41,6 +41,7 @@
 		compatible = "samsung,s3c6410-clock";
 		reg = <0x7e00f000 0x1000>;
 		#clock-cells = <1>;
+		#power-domain-cells = <1>;
 	};
 
 	i2c1: i2c@7f00f000 {
-- 
1.8.5.2

