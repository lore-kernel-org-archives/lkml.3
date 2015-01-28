Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbbA2CSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:18:18 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33420 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbbA2CSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:18:14 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v3 01/10] ARM: tegra: Set the sound card model that alsaucm expects
Date: Wed, 28 Jan 2015 11:50:59 +0100
Message-Id: <1422442278-10405-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1422442278-10405-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches are on its way to add a config file to alsaucm for the Nyan
boards. Use the same card ID that alsaucm will expect.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 004e8e4..eda6ae7 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -1108,9 +1108,9 @@
 	};
 
 	sound {
-		compatible = "nvidia,tegra-audio-max98090-nyan-big",
+		compatible = "nvidia,tegra-audio-max98090-nyan",
 			     "nvidia,tegra-audio-max98090";
-		nvidia,model = "Acer Chromebook 13";
+		nvidia,model = "GoogleNyan";
 
 		nvidia,audio-routing =
 			"Headphones", "HPR",
-- 
1.9.3

