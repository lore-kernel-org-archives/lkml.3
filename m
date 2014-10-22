Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaJVPXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:23:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35479 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaJVPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:23:28 -0400
From: Romain Perier <romain.perier@gmail.com>
To: sameo@linux.intel.com
Cc: lee.jones@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        broonie@kernel.org
Subject: [PATCH v1 4/5] ARM: dts: tegra: Use poweroff-source DT property in tps65911 for tegra30 cardhu
Date: Wed, 22 Oct 2014 15:26:26 +0000
Message-Id: <1413991587-11110-4-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 2063795..276784d 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -232,7 +232,7 @@
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
-			ti,system-power-controller;
+			poweroff-source;
 
 			#gpio-cells = <2>;
 			gpio-controller;
-- 
1.9.1

