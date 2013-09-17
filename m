Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3IQQLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:11:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36599 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3IQQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:11:43 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: swarren@wwwdotorg.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: Tegra updates, and driver ownership
Date: Tue, 17 Sep 2013 10:11:34 -0600
Message-Id: <1379434294-10128-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Overhaul of MAINTAINERS for Tegra. This adds Thierry as a Tegra core
maintainer, and adds specific entries for most individual Tegra-specific
device drivers, pointing at relevant people. The tegradrm section is
updated to be Supported since Thierry is now employed to work on this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
---
 MAINTAINERS | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 81415f6..75397a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2802,7 +2802,7 @@ M:	Terje Bergström <tbergstrom@nvidia.com>
 L:	dri-devel@lists.freedesktop.org
 L:	linux-tegra@vger.kernel.org
 T:	git git://anongit.freedesktop.org/tegra/linux.git
-S:	Maintained
+S:	Supported
 F:	drivers/gpu/host1x/
 F:	include/uapi/drm/tegra_drm.h
 F:	Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
@@ -8269,14 +8269,72 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/rc/ttusbir.c
 
-TEGRA SUPPORT
+TEGRA ARCHITECTURE SUPPORT
 M:	Stephen Warren <swarren@wwwdotorg.org>
+M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
 N:	[^a-z]tegra
 
+TEGRA ASOC DRIVER
+M:	Stephen Warren <swarren@wwwdotorg.org>
+S:	Supported
+F:	sound/soc/tegra/
+
+TEGRA CLOCK DRIVER
+M:	Peter De Schrijver <pdeschrijver@nvidia.com>
+M:	Prashant Gaikwad <pgaikwad@nvidia.com>
+S:	Supported
+F:	drivers/clk/tegra/
+
+TEGRA DMA DRIVER
+M:	Laxman Dewangan <ldewangan@nvidia.com>
+S:	Supported
+F:	drivers/dma/tegra20-apb-dma.c
+
+TEGRA GPIO DRIVER
+M:	Stephen Warren <swarren@wwwdotorg.org>
+S:	Supported
+F:	drivers/gpio/gpio-tegra.c
+
+TEGRA I2C DRIVER
+M:	Laxman Dewangan <ldewangan@nvidia.com>
+S:	Supported
+F:	drivers/i2c/busses/i2c-tegra.c
+
+TEGRA IOMMU DRIVERS
+M:	Hiroshi Doyu <hdoyu@nvidia.com>
+S:	Supported
+F:	drivers/iommu/tegra*
+
+TEGRA KBC DRIVER
+M:	Rakesh Iyer <riyer@nvidia.com>
+M:	Laxman Dewangan <ldewangan@nvidia.com>
+S:	Supported
+F:	drivers/input/keyboard/tegra-kbc.c
+
+TEGRA PINCTRL DRIVER
+M:	Stephen Warren <swarren@wwwdotorg.org>
+S:	Supported
+F:	drivers/pinctrl/pinctrl-tegra*
+
+TEGRA PWM DRIVER
+M:	Thierry Reding <thierry.reding@gmail.com>
+S:	Supported
+F:	drivers/pwm/pwm-tegra.c
+
+TEGRA SERIAL DRIVER
+M:	Laxman Dewangan <ldewangan@nvidia.com>
+S:	Supported
+F:	drivers/tty/serial/serial-tegra.c
+
+TEGRA SPI DRIVER
+M:	Laxman Dewangan <ldewangan@nvidia.com>
+S:	Supported
+F:	drivers/spi/spi-tegra*
+
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
 L:	netdev@vger.kernel.org
-- 
1.8.1.5

