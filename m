Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764397AbbA2Dlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:41:44 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59266 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbbA2BjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:39:05 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:37 2015
Subject: [PATCH 06/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra APB_MISC
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Kumar Gala <galak@codeaurora.org>, linux-tegra@vger.kernel.org
Date: Wed, 28 Jan 2015 16:49:37 -0700
Message-ID: <20150128234937.20644.82091.stgit@dusk.lan>
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


Add compatible strings for the APB_MISC IP blocks present on several Tegra
chips.  The primary objective here is to avoid checkpatch warnings,
per:

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
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: devicetree@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/misc/nvidia,tegra20-apbmisc.txt       |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
index b97b8bef1fe5..2723f3e4e52d 100644
--- a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
+++ b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
@@ -3,9 +3,10 @@ NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 apbmisc block
 Required properties:
 - compatible : should be:
        "nvidia,tegra20-apbmisc"
-       "nvidia,tegra30-apbmisc"
-       "nvidia,tegra114-apbmisc"
-       "nvidia,tegra124-apbmisc"
+       "nvidia,tegra30-apbmisc" (not yet matched in the driver)
+       "nvidia,tegra114-apbmisc" (not yet matched in the driver)
+       "nvidia,tegra124-apbmisc" (not yet matched in the driver)
+       "nvidia,tegra132-apbmisc" (not yet matched in the driver)
 - reg: Should contain 2 entries: the first entry gives the physical address
        and length of the registers which contain revision and debug features.
        The second entry gives the physical address and length of the


