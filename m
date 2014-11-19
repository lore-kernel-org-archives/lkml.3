Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaKSP4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:56:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaKSP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:56:05 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
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
Subject: [PATCH 1/4] ARM: dts: Add usb3503 pinctrl to exynos5250-spring
Date: Wed, 19 Nov 2014 16:56:21 +0100
Message-Id: <1416412585-10809-2-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416412585-10809-1-git-send-email-afaerber@suse.de>
References: <1416412585-10809-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/boot/dts/exynos5250-spring.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-spring.dts b/arch/arm/boot/dts/exynos5250-spring.dts
index f5566f84d885..310764b6e28d 100644
--- a/arch/arm/boot/dts/exynos5250-spring.dts
+++ b/arch/arm/boot/dts/exynos5250-spring.dts
@@ -52,6 +52,8 @@
 	usb-hub {
 		compatible = "smsc,usb3503a";
 		reset-gpios = <&gpe1 0 GPIO_ACTIVE_LOW>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hsic_reset>;
 	};
 
 	fixed-rate-clocks {
-- 
2.1.2

