Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaCLMWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:22:48 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36986 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaCLMVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:21:32 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 2/3] spi/xtensa-xtfpga: add DT binding documentation
Date: Wed, 12 Mar 2014 16:21:04 +0400
Message-Id: <1394626865-15105-3-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394626865-15105-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394626865-15105-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt b/Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt
new file mode 100644
index 0000000..b6ebe2b
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt
@@ -0,0 +1,9 @@
+Cadence Xtensa XTFPGA platform SPI controller.
+
+This simple SPI master controller is built into xtfpga bitstreams and is used
+to control daughterboard audio codec.
+
+Required properties:
+- compatible: should be "cdns,xtfpga-spi".
+- reg: physical base address of the controller and length of memory mapped
+  region.
-- 
1.8.1.4

