Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaI2MGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:06:00 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48891 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaI2MFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:05:55 -0400
From: zhang.lyra@gmail.com
To: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: [PATCH 6/6] Documentation: Add entry for Spreadtrum's Shark64 SoC
Date: Mon, 29 Sep 2014 20:04:53 +0800
Message-Id: <1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>

Adds a devicetree binding documentation for Spreadtrum's Shark64 SoC.

Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
---
 Documentation/devicetree/bindings/arm/sprd.txt |    6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt

diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
new file mode 100644
index 0000000..b6dc143
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sprd.txt
@@ -0,0 +1,6 @@
+Spreadtrum Platforms Device Tree Bindings
+----------------------------------------------------
+
+Shark64 Board
+Required root node properties:
+        - compatible = "sprd,shark64";
-- 
1.7.9.5

