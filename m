Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGJVvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:51:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:33895 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaGJVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:51 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jean Delvare <khali@linux-fr.org>, Jingoo Han <jg1.han@samsung.com>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Chris Cheney <chris.cheney@gmail.com>,
        Christoph Lameter <cl@gentwo.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Sebastian Reichel <sre@debian.org>, Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 14/83] hsa/radeon: Update MAINTAINERS and CREDITS files
Date: Fri, 11 Jul 2014 00:50:14 +0300
Message-Id: <1405029027-6085-13-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update MAINTAINERS and CREDITS files with kfd driver information

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 CREDITS     | 7 +++++++
 MAINTAINERS | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/CREDITS b/CREDITS
index 03343bf..c5f0aeae 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1197,6 +1197,13 @@ S: R. Tocantins, 89 - Cristo Rei
 S: 80050-430 - Curitiba - Paraná
 S: Brazil
 
+N: Oded Gabbay
+E: oded.gabbay@gmail.com
+D: AMD HSA Radeon (KFD) driver maintainer
+S: 12 Shraga Raphaeli
+S: Petah-Tikva, 4906418
+S: Israel
+
 N: Kumar Gala
 E: galak@kernel.crashing.org
 D: Embedded PowerPC 6xx/7xx/74xx/82xx/83xx/85xx support
diff --git a/MAINTAINERS b/MAINTAINERS
index 3efbeaf..bf1081f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -592,6 +592,14 @@ F:	drivers/crypto/geode*
 F:	drivers/video/fbdev/geode/
 F:	arch/x86/include/asm/geode.h
 
+AMD HSA RADEON DRIVER (KFD)
+M:	Oded Gabbay <oded.gabbay@amd.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/hsa/radeon
+F:	include/linux/radeon_kfd.h
+F:	include/linux/uapi/linux/kfd_ioctl.h
+
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 L:	iommu@lists.linux-foundation.org
-- 
1.9.1

