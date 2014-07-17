Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaGQNcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:32:16 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:11208
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756732AbaGQNcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:32:09 -0400
X-WSS-ID: 0N8UYXE-08-6WB-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jean Delvare <khali@linux-fr.org>, "Jiri Kosina" <jkosina@suse.cz>,
        Jingoo Han <jg1.han@samsung.com>, "Sebastian Reichel" <sre@debian.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Chris Cheney <chris.cheney@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Joe Perches" <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 07/25] Update MAINTAINERS and CREDITS files with amdkfd info
Date: Thu, 17 Jul 2014 16:29:14 +0300
Message-ID: <1405603773-32688-8-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(101416001)(84676001)(92566001)(83072002)(20776003)(76176999)(104166001)(102836001)(68736004)(31966008)(76482001)(46102001)(93916002)(33646002)(106466001)(95666004)(97736001)(50986999)(80022001)(92726001)(50226001)(47776003)(62966002)(81342001)(79102001)(21056001)(86362001)(85306003)(77096002)(87286001)(64706001)(74502001)(87936001)(229853001)(36756003)(77156001)(81542001)(77982001)(85852003)(4396001)(50466002)(107046002)(19580405001)(83322001)(44976005)(89996001)(19580395003)(105586002)(74662001)(99396002)(88136002)(23676002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
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
index 03343bf..ae47364 100644
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
index 3efbeaf..776b039 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -592,6 +592,16 @@ F:	drivers/crypto/geode*
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

