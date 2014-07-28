Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaG1NFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:05:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaG1NFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:05:21 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3] Documentation: devicetree: Fix ADI AXI SPDIF specification
Date: Mon, 28 Jul 2014 15:05:03 +0200
Message-Id: <1406552704-6736-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The specification requires compatible = "adi,axi-spdif-1.00.a" but
driver and example and file name indicate "adi,axi-spdif-tx-1.00.a".
Change the specification to match the implementation.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Fixes: d7b528eff927 ("dt: Add bindings documentation for the ADI AXI-SPDIF audio controller")
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2 -> v3:
 * Added Fixes header
 * CC broonie (Mark Brown)
 
 v2: New
 
 Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt b/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
index 46f344965313..4eb7997674a0 100644
--- a/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
+++ b/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
@@ -1,7 +1,7 @@
 ADI AXI-SPDIF controller
 
 Required properties:
- - compatible : Must be "adi,axi-spdif-1.00.a"
+ - compatible : Must be "adi,axi-spdif-tx-1.00.a"
  - reg : Must contain SPDIF core's registers location and length
  - clocks : Pairs of phandle and specifier referencing the controller's clocks.
    The controller expects two clocks, the clock used for the AXI interface and
-- 
1.9.3

