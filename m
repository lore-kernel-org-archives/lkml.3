Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764Ab3FTVjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:39:13 -0400
Received: from www.tglx.de ([62.245.132.106]:49078 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965728Ab3FTVjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:39:11 -0400
X-Greylist: delayed 1846 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 17:39:11 EDT
Date: Thu, 20 Jun 2013 23:08:14 +0200 (CEST)
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
X-X-Sender: anna-maria@dionysos
To: linux-tegra@vger.kernel.org
cc: Joseph Lo <josephl@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM:tegra20-colibri-512.dts: Change tristate status for i2c
 pinmux
Message-ID: <alpine.DEB.2.02.1306202302210.11096@dionysos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nvidia,tristate entry for the pinmux of i2c1 an i2c3 was set to
tristate. This results in non working i2c, because the i2c pins are
not actively driven. Set the entries to "driven".

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index 4441620..ad699bb 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -86,13 +86,13 @@
  				nvidia,pins = "rm";
  				nvidia,function = "i2c1";
  				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,tristate = <0>;
  			};
  			i2c3 {
  				nvidia,pins = "dtf";
  				nvidia,function = "i2c3";
  				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,tristate = <0>;
  			};
  			i2cddc {
  				nvidia,pins = "ddc";
