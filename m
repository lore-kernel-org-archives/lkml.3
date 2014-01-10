Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaAJHC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:02:27 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34886 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaAJHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 16/16] ARM: dts: sun7i: Add ethernet alias for GMAC
Date: Fri, 10 Jan 2014 15:00:17 +0800
Message-Id: <1389337217-29032-17-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

U-Boot will insert MAC address into the device tree image.
It looks up ethernet[0-5] aliases to find the ethernet nodes.
Alias GMAC as ethernet0, as it is the only ethernet controller used.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index b18f18f..897dbfc 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -17,7 +17,7 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
-		ethernet0 = &emac;
+		ethernet0 = &gmac;
 	};
 
 	cpus {
-- 
1.8.5.2

