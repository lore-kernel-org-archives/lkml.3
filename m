Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3KNO4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:56:42 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:42071 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab3KNO4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:56:33 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH] ARM: dove: Fix typo in device_type property of phy node
Date: Thu, 14 Nov 2013 14:54:59 +0000
Message-ID: <1384440899-3622-1-git-send-email-srinivas.kandagatla@st.com>
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
 arch/arm/boot/dts/dove.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index cc27916..b4a6559 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -481,7 +481,7 @@
 			status = "disabled";
 
 			ethphy: ethernet-phy {
-				device-type = "ethernet-phy";
+				device_type = "ethernet-phy";
 				/* set phy address in board file */
 			};
 		};
-- 
1.7.6.5

