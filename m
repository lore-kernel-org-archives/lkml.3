Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3KNOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:55:16 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:55997 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab3KNOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:55:09 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH] ARM: orion5x: Fix typo in device_type property of phy node
Date: Thu, 14 Nov 2013 14:53:08 +0000
Message-ID: <1384440788-3529-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo for device_type property of phy node.
This can work as of today but once a checks are added in generic code
this typo will stop phy from working.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
index aed83de..fcc5bb6 100644
--- a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
+++ b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
@@ -58,7 +58,7 @@
 	status = "okay";
 
 	ethphy: ethernet-phy {
-		device-type = "ethernet-phy";
+		device_type = "ethernet-phy";
 		reg = <8>;
 	};
 };
-- 
1.7.6.5

