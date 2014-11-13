Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaKMOyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:54:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39260 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbaKMOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:54:41 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <afenkart@gmail.com>, <nsekhar@ti.com>, <kishon@ti.com>
Subject: [RFC PATCH 3/3] ARM: dts: dra72-evm: Set the max-frequency to 192MHz
Date: Thu, 13 Nov 2014 20:24:18 +0530
Message-ID: <1415890458-20436-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415890458-20436-1-git-send-email-kishon@ti.com>
References: <1415890458-20436-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the maximum operating frequency of MMC2 to 192MHz.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/dra72-evm.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index abbaaa7..5cc1110 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -364,6 +364,7 @@
 	vmmc-supply = <&evm_3v3>;
 	bus-width = <8>;
 	ti,non-removable;
+	max-frequency = <192000000>;
 };
 
 &dra7_pmx_core {
-- 
1.7.9.5

