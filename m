Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbbA2Ccc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:32:32 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59580 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbbA2BrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:16 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:37 2015
Subject: [PATCH 09/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra PWM
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-tegra@vger.kernel.org
Date: Wed, 28 Jan 2015 16:49:37 -0700
Message-ID: <20150128234937.20644.4804.stgit@dusk.lan>
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


Add compatible strings for the PWM IP blocks present on several Tegra
chips.  The primary objective here is to avoid checkpatch warnings,
per:

http://marc.info/?l=linux-tegra&m=142201349727836&w=2

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-pwm@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/pwm/nvidia,tegra20-pwm.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
index c7ea9d4a988b..f3390f602378 100644
--- a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
@@ -4,6 +4,10 @@ Required properties:
 - compatible: should be one of:
   - "nvidia,tegra20-pwm"
   - "nvidia,tegra30-pwm"
+  - "nvidia,tegra114-pwm" (not yet matched by the driver)
+  - "nvidia,tegra124-pwm" (not yet matched by the driver)
+  - "nvidia,tegra132-pwm" (not yet matched by the driver)
+  - "nvidia,tegra210-pwm" (not yet matched by the driver)
 - reg: physical base address and length of the controller's registers
 - #pwm-cells: should be 2. See pwm.txt in this directory for a description of
   the cells format.


