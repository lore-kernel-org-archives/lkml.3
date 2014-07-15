Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaGORCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:22 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49505 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbaGORCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:06 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 01/94] ARM: shmobile: Add DT and defconfigs to MAINTAINERS
Date: Tue, 15 Jul 2014 20:00:16 +0300
Message-Id: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms+renesas@verge.net.au>

There are a number of DT and defconfig files which
are maintained as part of shmobile but have not been
listed as such in the MAINTAINERS file. This creates
confusion from time to time.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c411c40..e31c874 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1314,6 +1314,20 @@ W:	http://oss.renesas.com
 Q:	http://patchwork.kernel.org/project/linux-sh/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git next
 S:	Supported
+F:	arch/arm/boot/dts/emev2*
+F:	arch/arm/boot/dts/r7s*
+F:	arch/arm/boot/dts/r8a*
+F:	arch/arm/boot/dts/sh*
+F:	arch/arm/configs/ape6evm_defconfig
+F:	arch/arm/configs/armadillo800eva_defconfig
+F:	arch/arm/configs/bockw_defconfig
+F:	arch/arm/configs/genmai_defconfig
+F:	arch/arm/configs/koelsch_defconfig
+F:	arch/arm/configs/kzm9g_defconfig
+F:	arch/arm/configs/lager_defconfig
+F:	arch/arm/configs/mackerel_defconfig
+F:	arch/arm/configs/marzen_defconfig
+F:	arch/arm/configs/shmobile_defconfig
 F:	arch/arm/mach-shmobile/
 F:	drivers/sh/
 
-- 
1.7.10.4

