Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbbA2BjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:39:06 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59261 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbbA2BjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:39:03 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:37 2015
Subject: [PATCH 05/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra AHB gizmo
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Kumar Gala <galak@codeaurora.org>, linux-tegra@vger.kernel.org
Date: Wed, 28 Jan 2015 16:49:37 -0700
Message-ID: <20150128234937.20644.58615.stgit@dusk.lan>
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


Add compatible strings for the AHB "gizmo" IP block present on several
Tegra chips.  The primary objective here is to avoid checkpatch
warnings, per:

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
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: devicetree@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/arm/tegra/nvidia,tegra20-ahb.txt      |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
index 234406d41c12..fef3a9ecb798 100644
--- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
@@ -1,7 +1,11 @@
 NVIDIA Tegra AHB
 
 Required properties:
-- compatible : "nvidia,tegra20-ahb" or "nvidia,tegra30-ahb"
+- compatible : "nvidia,tegra20-ahb"
+  "nvidia,tegra30-ahb"
+  "nvidia,tegra124-ahb" (not yet matched by the driver)
+  "nvidia,tegra132-ahb" (not yet matched by the driver)
+  "nvidia,tegra210-ahb" (not yet matched by the driver)
 - reg : Should contain 1 register ranges(address and length)
 
 Example:


