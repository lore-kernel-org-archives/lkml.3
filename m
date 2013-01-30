Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3A3DC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:02:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13673 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3A3DCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 29 Jan 2013 19:00:57 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 4/4] tegra: enable CDF and claa101 panel
Date: Wed, 30 Jan 2013 12:02:19 +0900
Message-ID: <1359514939-15653-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/configs/tegra_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index a7827fd..6da0de2 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -150,6 +150,8 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
 # CONFIG_BACKLIGHT_GENERIC is not set
 CONFIG_BACKLIGHT_PWM=y
+CONFIG_DISPLAY_CORE=y
+CONFIG_DISPLAY_PANEL_CLAA101WA01A=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
 CONFIG_SOUND=y
-- 
1.8.1.1

