Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3DLLFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:05:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab3DLLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:05:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MAINTAINERS: Update e-mail address
Date: Fri, 12 Apr 2013 12:04:56 +0100
Message-Id: <1365764696-12030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the e-mail address I use for subsystems.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 836a618..c6108c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6625,7 +6625,7 @@ S:	Supported
 F:	fs/reiserfs/
 
 REGISTER MAP ABSTRACTION
-M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Mark Brown <broonie@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
 S:	Supported
 F:	drivers/base/regmap/
@@ -7374,7 +7374,7 @@ F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
 M:	Liam Girdwood <lgirdwood@gmail.com>
-M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Mark Brown <broonie@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://alsa-project.org/main/index.php/ASoC
@@ -7463,7 +7463,7 @@ F:	drivers/clk/spear/
 
 SPI SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
-M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Mark Brown <broonie@kernel.org>
 L:	spi-devel-general@lists.sourceforge.net
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
 T:	git git://git.secretlab.ca/git/linux-2.6.git
@@ -8708,7 +8708,7 @@ F:	drivers/scsi/vmw_pvscsi.h
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
 M:	Liam Girdwood <lrg@ti.com>
-M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Mark Brown <broonie@kernel.org>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/regulator.git
-- 
1.7.10.4

