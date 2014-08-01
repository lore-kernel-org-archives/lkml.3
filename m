Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaHAE5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:57:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaHAE5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:57:03 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 08/10] ARM: dts: Fix apparent GPIO typo in exynos5250-arndale
Date: Fri,  1 Aug 2014 06:54:55 +0200
Message-Id: <1406868897-26874-9-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406868897-26874-1-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO flag 2 has no constant assigned, so this was probably active-low.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v5: New
 Spotted during cleanup.

 arch/arm/boot/dts/exynos5250-arndale.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 3a608f57f833..a04a875346aa 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -164,7 +164,7 @@
 };
 
 &hdmi {
-	hpd-gpio = <&gpx3 7 2>;
+	hpd-gpio = <&gpx3 7 GPIO_ACTIVE_LOW>;
 	vdd_osc-supply = <&ldo10_reg>;
 	vdd_pll-supply = <&ldo8_reg>;
 	vdd-supply = <&ldo8_reg>;
-- 
1.9.3

