Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3KFMTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:19:32 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10517 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3KFMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:19:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Nov 2013 04:18:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/5] mfd: as3722: add DT details for clock support of ams AS3722
Date: Wed, 6 Nov 2013 17:48:20 +0530
Message-ID: <1383740303-10956-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
References: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT details for using the clocks from ams AS3722.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- This is new patch of series which was part of code change, splitting it
 on different change.

 Documentation/devicetree/bindings/mfd/as3722.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
index fc2191e..e782f39 100644
--- a/Documentation/devicetree/bindings/mfd/as3722.txt
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -112,6 +112,15 @@ Following are properties of regulator subnode.
 		ams,enable-tracking: Enable tracking with SD1, only supported
 			by LDO3.
 
+Clock:
+======
+AS3722 supports one 32KHz clock to output from device. The clock control is
+provided through the clock driver.
+This binding uses the common clock binding ./clock-bindings.txt.
+The device node should have the optional properties to support the clock:
+#clock-cells: from common clock binding; shall be set to 1. The clock id for
+	single clock output is 0.
+
 Example:
 --------
 #include <dt-bindings/mfd/as3722.h>
-- 
1.7.1.1

