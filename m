Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbbA2Bok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:40 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59443 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbbA2Boh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:37 -0500
MBOX-Line: From nobody Wed Jan 28 16:49:38 2015
Subject: [PATCH 15/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra AHCI
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        linux-tegra@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Kumar Gala <galak@codeaurora.org>, Tejun Heo <tj@kernel.org>
Date: Wed, 28 Jan 2015 16:49:38 -0700
Message-ID: <20150128234938.20644.37736.stgit@dusk.lan>
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


Add compatible strings for the AHCI IP blocks present on several Tegra
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
Cc: Tejun Heo <tj@kernel.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Paul Walmsley <pwalmsley@nvidia.com>
Cc: devicetree@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/ata/tegra-sata.txt         |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ata/tegra-sata.txt b/Documentation/devicetree/bindings/ata/tegra-sata.txt
index 946f2072570b..2c44860d075e 100644
--- a/Documentation/devicetree/bindings/ata/tegra-sata.txt
+++ b/Documentation/devicetree/bindings/ata/tegra-sata.txt
@@ -1,7 +1,8 @@
 Tegra124 SoC SATA AHCI controller
 
 Required properties :
-- compatible : "nvidia,tegra124-ahci".
+- compatible : "nvidia,tegra124-ahci",
+  "nvidia,tegra132-ahci" (not yet matched by the driver)
 - reg : Should contain 2 entries:
   - AHCI register set (SATA BAR5)
   - SATA register set


