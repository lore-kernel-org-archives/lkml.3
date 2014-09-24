Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaIXVCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:02:41 -0400
Received: from mail-by2on0137.outbound.protection.outlook.com ([207.46.100.137]:38448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378AbaIXVCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:02:36 -0400
X-WSS-ID: 0NCFB37-08-8G3-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jean Delvare <khali@linux-fr.org>, Jingoo Han <jg1.han@samsung.com>,
        Joe Perches <joe@perches.com>, Christoph Lameter <cl@gentwo.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Michael Opdenacker" <michael.opdenacker@free-electrons.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH v4 06/23] Update MAINTAINERS and CREDITS files with amdkfd info
Date: Wed, 24 Sep 2014 23:45:20 +0300
Message-ID: <1411591537-31636-7-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(85306004)(77096002)(36756003)(83072002)(50986999)(97736003)(76176999)(62966002)(107046002)(19580405001)(77156001)(229853001)(33646002)(105586002)(76482002)(85852003)(106466001)(101416001)(99396003)(10300001)(90102001)(44976005)(120916001)(19580395003)(95666004)(102836001)(21056001)(87936001)(89996001)(87286001)(81342003)(88136002)(68736004)(83322001)(23676002)(93916002)(50466002)(80022003)(92726001)(86362001)(20776003)(81542003)(46102003)(47776003)(77982003)(79102003)(84676001)(92566001)(74502003)(31966008)(50226001)(64706001)(4396001)(104166001)(74662003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 CREDITS     |  7 +++++++
 MAINTAINERS | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/CREDITS b/CREDITS
index bb62788..c56d8aa 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1197,6 +1197,13 @@ S: R. Tocantins, 89 - Cristo Rei
 S: 80050-430 - Curitiba - Paraná
 S: Brazil
 
+N: Oded Gabbay
+E: oded.gabbay@gmail.com
+D: AMD KFD maintainer
+S: 12 Shraga Raphaeli
+S: Petah-Tikva, 4906418
+S: Israel
+
 N: Kumar Gala
 E: galak@kernel.crashing.org
 D: Embedded PowerPC 6xx/7xx/74xx/82xx/83xx/85xx support
diff --git a/MAINTAINERS b/MAINTAINERS
index dd31933..437ff7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -609,6 +609,16 @@ F:	drivers/crypto/geode*
 F:	drivers/video/fbdev/geode/
 F:	arch/x86/include/asm/geode.h
 
+AMD KFD (radeon extension)
+M:	Oded Gabbay <oded.gabbay@amd.com>
+L:	dri-devel@lists.freedesktop.org
+T:	git git://people.freedesktop.org/~gabbayo/linux.git
+S:	Supported
+F:	drivers/gpu/drm/radeon/amdkfd/*
+F:	drivers/gpu/drm/radeon/radeon_kfd.c
+F:	drivers/gpu/drm/radeon/radeon_kfd.h
+F:	include/linux/uapi/linux/kfd_ioctl.h
+
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joro@8bytes.org>
 L:	iommu@lists.linux-foundation.org
-- 
1.9.1

