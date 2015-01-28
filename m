Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbbA1Umo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:44 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46208 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbbA1Uml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 6/6] ARM: dts: exynos5250-snow: Add cap-sdio-irq to wifi mmc node
Date: Wed, 28 Jan 2015 19:15:53 +0100
Message-Id: <1422468953-7594-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling SDIO IRQ signalling for the wifi MMC/SDIO slot
doubles the transmission transfer rate.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1: None, new patch.
---
 arch/arm/boot/dts/exynos5250-snow.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index b78712058903..909edc3448d3 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -539,6 +539,7 @@
 	status = "okay";
 	num-slots = <1>;
 	broken-cd;
+	cap-sdio-irq;
 	card-detect-delay = <200>;
 	samsung,dw-mshc-ciu-div = <3>;
 	samsung,dw-mshc-sdr-timing = <2 3>;
-- 
2.1.3

