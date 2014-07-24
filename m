Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbaGXWSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:18:07 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:59604 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaGXWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:18:04 -0400
From: Doug Anderson <dianders@chromium.org>
To: heiko@sntech.de
Cc: linux-arm-kernel@lists.infradead.org, Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Build dtbs for Rockchip boards
Date: Thu, 24 Jul 2014 15:17:50 -0700
Message-Id: <1406240270-13278-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the "make dtbs" target to work.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
This is built upon (ARM: dts: add rk3288 evaluation board) at
<https://patchwork.kernel.org/patch/4579541/>, which won't actually
build without the bindings that just landed in today's clk-next.

 arch/arm/boot/dts/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 82f498b..026f61d 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -341,6 +341,11 @@ dtb-$(CONFIG_ARCH_QCOM) += \
 	qcom-apq8084-mtp.dtb \
 	qcom-msm8660-surf.dtb \
 	qcom-msm8960-cdp.dtb
+dtb-$(CONFIG_ARCH_ROCKCHIP) += \
+	rk3066a-bqcurie2.dtb \
+	rk3188-radxarock.dtb \
+	rk3288-evb-act8846.dtb \
+	rk3288-evb-rk808.dtb
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
 dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb \
 	s3c6410-smdk6410.dtb
-- 
2.0.0.526.g5318336

