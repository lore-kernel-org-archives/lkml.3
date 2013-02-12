Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab3BLAjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:39:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761082Ab3BLAjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:39:42 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: arm@kernel.org
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 2/2] MAINTAINERS: update Tegra section to capture all Tegra files
Date: Mon, 11 Feb 2013 17:39:33 -0700
Message-Id: <1360629574-23989-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org>
References: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The intent is to ensure that all Tegra-related patches are sent to the
linux-tegra@ mailing list, so people can keep up-to-date on all misc
driver changes.

Doing this with a keyword is far simpler and more compact than listing
all Tegra-related drivers, even if wildcards were used.

Words such as integrate or integrator are common. Ensure the character
right before "tegra" isn't a-z (case-insensitive), to make sure the
keyword doesn't match those.

The only files that the keyword doesn't match are the NVEC driver. Add
the linux-tegra mailing list to the NVEC entry to solve this.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
V4: No change.
---
 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fbba896..f42f82f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7566,6 +7566,7 @@ STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
 M:	Julian Andres Klode <jak@jak-linux.org>
 M:	Marc Dietrich <marvin24@gmx.de>
 L:	ac100@lists.launchpad.net (moderated for non-subscribers)
+L:	linux-tegra@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/nvec/
 
@@ -7864,9 +7865,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-F:	arch/arm/mach-tegra
-F:	arch/arm/boot/dts/tegra*
-F:	arch/arm/configs/tegra_defconfig
+K:	(?i)[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
-- 
1.7.10.4

