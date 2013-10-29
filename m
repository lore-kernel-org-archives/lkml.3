Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3J2MU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:20:59 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12632 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3J2MUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:20:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Oct 2013 05:20:12 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] mfd: AS3722: add dt node properties for system power controller
Date: Tue, 29 Oct 2013 17:50:04 +0530
Message-ID: <1383049205-29620-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
References: <1383049205-29620-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ams AS3722 device supports the power off by turning off its all rails.

Add dt node properties to enable this functionality on this device.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 Documentation/devicetree/bindings/mfd/as3722.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
index e782f39..1a2fa8a 100644
--- a/Documentation/devicetree/bindings/mfd/as3722.txt
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -121,6 +121,15 @@ The device node should have the optional properties to support the clock:
 #clock-cells: from common clock binding; shall be set to 1. The clock id for
 	single clock output is 0.
 
+Power-off:
+=========
+
+AS3722 supports the system power off by turning off all its rail. The power off
+is provided through pm power off.
+The device node should have the following properties to enable power-off
+functionality from ams AS3722:
+ams,system-power-controller: To enable the power off functionality through
+	device.
 Example:
 --------
 #include <dt-bindings/mfd/as3722.h>
-- 
1.7.1.1

