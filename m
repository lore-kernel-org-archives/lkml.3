Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaJVPYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:24:01 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33622 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaJVPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:23:26 -0400
From: Romain Perier <romain.perier@gmail.com>
To: sameo@linux.intel.com
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        broonie@kernel.org
Subject: [PATCH v1 3/5] ARM: dts: tegra: Use poweroff-source DT property in tps65911 for tegra30 beaver
Date: Wed, 22 Oct 2014 15:26:25 +0000
Message-Id: <1413991587-11110-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/arm/boot/dts/tegra30-beaver.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index cee8f22..47e01b6 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -188,7 +188,7 @@
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
-			ti,system-power-controller;
+			poweroff-source;
 
 			#gpio-cells = <2>;
 			gpio-controller;
-- 
1.9.1

