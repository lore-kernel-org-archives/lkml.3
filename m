Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbbA2BmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:42:00 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59363 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbbA2Bl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:57 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:37 2015
Subject: [PATCH 07/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra124 pinmux
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Kumar Gala <galak@codeaurora.org>, linux-tegra@vger.kernel.org,
        Sean Paul <seanpaul@chromium.org>
Date: Wed, 28 Jan 2015 16:49:37 -0700
Message-ID: <20150128234937.20644.9760.stgit@dusk.lan>
In-Reply-To: <20150128234935.20644.89300.stgit@dusk.lan>
References: <20150128234935.20644.89300.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a Tegra132 compatible string to the pinmux IP blocks present on
chips similar to Tegra124.  The primary objective here is to avoid
checkpatch warnings, per:

http://marc.info/?l=linux-tegra&m=142201349727836&w=2

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: devicetree@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/pinctrl/nvidia,tegra124-pinmux.txt    |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
index 189814e7cdc7..4eb7163a2eb8 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-pinmux.txt
@@ -7,6 +7,7 @@ a baseline, and only documents the differences between the two bindings.
 
 Required properties:
 - compatible: "nvidia,tegra124-pinmux"
+  "nvidia,tegra132-pinmux" (not yet matched in the driver)
 - reg: Should contain a list of base address and size pairs for:
     -- first entry - the drive strength and pad control registers.
     -- second entry - the pinmux registers


