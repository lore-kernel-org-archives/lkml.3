Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaCLSIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:08:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:32849 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbaCLSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:07:58 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND timing mode property
Date: Wed, 12 Mar 2014 19:07:39 +0100
Message-Id: <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for the ONFI NAND timing mode property.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 Documentation/devicetree/bindings/mtd/nand.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
index b53f92e..2046027 100644
--- a/Documentation/devicetree/bindings/mtd/nand.txt
+++ b/Documentation/devicetree/bindings/mtd/nand.txt
@@ -19,3 +19,11 @@ errors per {size} bytes".
 The interpretation of these parameters is implementation-defined, so not all
 implementations must support all possible combinations. However, implementations
 are encouraged to further specify the value(s) they support.
+
+- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
+  the NAND chip. Each supported mode is represented as a bit position (i.e. :
+  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
+  This is only used when the chip does not support the ONFI standard.
+  The last bit set represent the closest mode fulfilling the NAND chip timings.
+  For a full description of the different timing modes see this document:
+  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf
-- 
1.7.9.5

