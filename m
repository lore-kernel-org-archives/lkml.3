Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3FGUsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:48:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44114 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3FGUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:48:44 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <tony@atomide.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Eduardo Valentin <eduardo.valentin@ti.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        AnilKumar Ch <anilkumar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 6/6] arm: omap2plus_defconfig: enable DRA752 thermal support by default
Date: Fri, 7 Jun 2013 16:46:08 -0400
Message-ID: <1370637968-23299-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make DRA752 thermal support enabled on omap2plus_defconfig

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 6e6c494..07aab0b 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -248,6 +248,7 @@ CONFIG_TI_SOC_THERMAL=y
 CONFIG_TI_THERMAL=y
 CONFIG_OMAP4_THERMAL=y
 CONFIG_OMAP5_THERMAL=y
+CONFIG_DRA752_THERMAL=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_FS_XATTR is not set
-- 
1.8.2.1.342.gfa7285d

