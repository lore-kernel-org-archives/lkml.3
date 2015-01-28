Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbbA2Blu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:50 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59354 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbbA2Blr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:47 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:37 2015
Subject: [PATCH 03/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra SOR
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Terje =?utf-8?q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        dri-devel@lists.freedesktop.org, Kumar Gala <galak@codeaurora.org>,
        linux-tegra@vger.kernel.org
Date: Wed, 28 Jan 2015 16:49:37 -0700
Message-ID: <20150128234937.20644.39714.stgit@dusk.lan>
In-Reply-To: <20150128234935.20644.89300.stgit@dusk.lan>
References: <20150128234935.20644.89300.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add compatible strings for the SOR IP blocks present on several Tegra
chips.  The primary objective here is to avoid checkpatch warnings,
per:

http://marc.info/?l=linux-tegra&m=142201349727836&w=2

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: "Terje Bergström" <tbergstrom@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/gpu/nvidia,tegra20-host1x.txt         |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
index 4c32ef0b7db8..0e828c00e7e4 100644
--- a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+++ b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
@@ -198,6 +198,7 @@ of the following host1x client modules:
 
   Required properties:
   - compatible: "nvidia,tegra124-sor"
+    "nvidia,tegra132-sor" (not yet matched in the driver)
   - reg: Physical base address and length of the controller's registers.
   - interrupts: The interrupt outputs from the controller.
   - clocks: Must contain an entry for each entry in clock-names.
@@ -223,6 +224,7 @@ of the following host1x client modules:
 
 - dpaux: DisplayPort AUX interface
   - compatible: "nvidia,tegra124-dpaux"
+    "nvidia,tegra132-dpaux" (not yet matched in the driver)
   - reg: Physical base address and length of the controller's registers.
   - interrupts: The interrupt outputs from the controller.
   - clocks: Must contain an entry for each entry in clock-names.


