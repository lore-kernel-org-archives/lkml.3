Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaGIMX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:23:59 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:53606 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaGIMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 11/13] [RFC] mmc: tmio-mmc: Add support for SDHI on new R-Car Gen2 SoCs
Date: Wed,  9 Jul 2014 14:23:41 +0200
Message-Id: <1404908623-909-12-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - r8a7792 (R-Car V2H)
  - r8a7793 (R-Car M2-N)
  - r8a7794 (R-Car E2)

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt | 3 +++
 drivers/mmc/host/sh_mobile_sdhi.c                  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
index fa0f327cde01..400b640fabc7 100644
--- a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
@@ -19,6 +19,9 @@ Required properties:
 		"renesas,sdhi-r8a7779" - SDHI IP on R8A7779 SoC
 		"renesas,sdhi-r8a7790" - SDHI IP on R8A7790 SoC
 		"renesas,sdhi-r8a7791" - SDHI IP on R8A7791 SoC
+		"renesas,sdhi-r8a7792" - SDHI IP on R8A7792 SoC
+		"renesas,sdhi-r8a7793" - SDHI IP on R8A7793 SoC
+		"renesas,sdhi-r8a7794" - SDHI IP on R8A7794 SoC
 
 Optional properties:
 - toshiba,mmc-wrprotect-disable: write-protect detection is unavailable
diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index 91058dabd11a..443c20969bd7 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -68,6 +68,9 @@ static const struct of_device_id sh_mobile_sdhi_of_match[] = {
 	{ .compatible = "renesas,sdhi-r8a7779", .data = &of_rcar_gen1_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7790", .data = &of_rcar_gen2_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7791", .data = &of_rcar_gen2_compatible, },
+	{ .compatible = "renesas,sdhi-r8a7792", .data = &of_rcar_gen2_compatible, },
+	{ .compatible = "renesas,sdhi-r8a7793", .data = &of_rcar_gen2_compatible, },
+	{ .compatible = "renesas,sdhi-r8a7794", .data = &of_rcar_gen2_compatible, },
 	{},
 };
 MODULE_DEVICE_TABLE(of, sh_mobile_sdhi_of_match);
-- 
1.9.1

