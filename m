Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934803AbaGXXCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:02:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717AbaGXXBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:20 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF specification
Date: Fri, 25 Jul 2014 01:00:18 +0200
Message-Id: <1406242820-20140-10-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The specification requires compatible = "adi,axi-spdif-1.00.a" but
driver and example and file name indicate "adi,axi-spdif-tx-1.00.a".
Change the specification to match the implementation.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New
 
 Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt b/Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt
index 46f3449..4eb7997 100644
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

