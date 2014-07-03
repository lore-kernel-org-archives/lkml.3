Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaGCUto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:49:44 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46861 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGCUtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:49:42 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, tony@atomide.com,
        linux@arm.linux.org.uk, balajitk@ti.com, chris@printf.net,
        ulf.hansson@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, hns@goldelico.com, marek@goldelico.com
Subject: [PATCH 2/2] Documentation: devicetree: mmc: Document reset-gpio property
Date: Thu,  3 Jul 2014 22:49:24 +0200
Message-Id: <1404420564-30245-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404420564-30245-1-git-send-email-marek@goldelico.com>
References: <1404420564-30245-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 431716e..b094bd2 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -21,6 +21,7 @@ Optional properties:
   below for the case, when a GPIO is used for the CD line
 - wp-inverted: when present, polarity on the WP line is inverted. See the note
   below for the case, when a GPIO is used for the WP line
+- reset-gpios: Specify GPIOs which will be hold down when turning power regulator
 - max-frequency: maximum operating clock frequency
 - no-1-8-v: when present, denotes that 1.8v card voltage is not supported on
   this system, even if the controller claims it is.
@@ -72,6 +73,7 @@ sdhci@ab000000 {
 	cd-gpios = <&gpio 69 0>;
 	cd-inverted;
 	wp-gpios = <&gpio 70 0>;
+	reset-gpios = <&gpio 71 0>;
 	max-frequency = <50000000>;
 	keep-power-in-suspend;
 	enable-sdio-wakeup;
-- 
1.9.1

