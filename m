Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaFSOID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:08:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60141 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756868AbaFSOIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:08:01 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mvebu: Fix missing binding documentation for Armada 38x
Date: Thu, 19 Jun 2014 16:07:51 +0200
Message-Id: <1403186871-28204-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the Armada 380 and Armada 385 SoCs, the common bindings for those
2 SoCs, was forgotten. This patch add the documentation for the
marvell,aramda38x property.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
Hi,

This fix should be merged in 3.16. For 3.15 I am not sure as it is not
a regression.

Thanks,
Gregory

 Documentation/devicetree/bindings/arm/armada-38x.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
index 11f2330a6554..b68bcb80d2de 100644
--- a/Documentation/devicetree/bindings/arm/armada-38x.txt
+++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
@@ -6,5 +6,9 @@ following property:
 
 Required root node property:
 
+compatible: must contain "marvell,armada38x"
+
+Required root node property:
+
  - compatible: must contain either "marvell,armada380" or
    "marvell,armada385" depending on the variant of the SoC being used.
-- 
1.8.1.2

