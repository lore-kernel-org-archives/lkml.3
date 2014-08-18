Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaHRO64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:58:56 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64918 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaHRO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:58:54 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, olof@lixom.net, arnd@arndb.de,
        jason@lakedaemon.net, thomas.petazzoni@free-electrons.com,
        swarren@nvidia.com, sebastian.hesselbarth@gmail.com, stefan@agner.ch,
        maxime.ripard@free-electrons.com, matthias.bgg@gmail.com,
        anders.berg@lsi.com, linus.walleij@linaro.org, lee.jones@linaro.org,
        heiko@sntech.de, srv_yingjoe.chen@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/9] arm: multi_v7_defconfig: Enable Mediatek platform
Date: Mon, 18 Aug 2014 16:58:30 +0200
Message-Id: <1408373917-10002-3-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
References: <1408373917-10002-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Mediatek platform support for multi_v7_defconfig.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 arch/arm/configs/multi_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5fb95fb..4c08101 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -42,6 +42,7 @@ CONFIG_SOC_AM33XX=y
 CONFIG_SOC_AM43XX=y
 CONFIG_SOC_DRA7XX=y
 CONFIG_ARCH_QCOM=y
+CONFIG_ARCH_MEDIATEK=y
 CONFIG_ARCH_MSM8X60=y
 CONFIG_ARCH_MSM8960=y
 CONFIG_ARCH_MSM8974=y
-- 
1.7.9.5

