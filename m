Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaFIHEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:04:06 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19471 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaFIHEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:04:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 08 Jun 2014 23:58:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>
CC: <robh+dt@kernel.org>, <swarren@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mark.rutland@arm.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] Doc: mfd: as3722: Add details of optional missing property
Date: Mon, 9 Jun 2014 12:33:37 +0530
Message-ID: <1402297417-9338-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add details of following properties which are used on driver but
not documented on DT binding document.
- ams,enable-internal-int-pullup
- ams,enable-internal-i2c-pullup

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/as3722.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
index 8edcb9b..4f64b2a 100644
--- a/Documentation/devicetree/bindings/mfd/as3722.txt
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -13,6 +13,14 @@ Required properties:
   The second cell is the flags, encoded as the trigger masks from binding document
 	interrupts.txt, using dt-bindings/irq.
 
+Optional properties:
+--------------------
+- ams,enable-internal-int-pullup: Boolean property, to enable internal pullup on
+	interrupt pin. Missing this will disable internal pullup on INT pin.
+- ams,enable-internal-i2c-pullup: Boolean property, to enable internal pullup on
+	i2c scl/sda pins. Missing this will disable internal pullup on i2c
+	scl/sda lines.
+
 Optional submodule and their properties:
 =======================================
 
-- 
1.8.1.5

