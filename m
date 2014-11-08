Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaKHSkC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:40:02 -0500
Received: from mail-bn1bon0112.outbound.protection.outlook.com ([157.56.111.112]:6702
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753891AbaKHSkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:40:00 -0500
X-WSS-ID: 0NEQH6K-07-RDQ-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        David Rientjes <rientjes@google.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Sebastian Reichel <sre@debian.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with amdkfd info
Date: Sat, 8 Nov 2014 20:37:27 +0200
Message-ID: <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(47776003)(20776003)(50466002)(62966003)(87286001)(77156002)(87936001)(88136002)(77096003)(89996001)(106466001)(84676001)(64706001)(120916001)(68736004)(36756003)(107046002)(19580405001)(19580395003)(99396003)(229853001)(104166001)(44976005)(33646002)(102836001)(97736003)(23676002)(46102003)(31966008)(76176999)(4396001)(50226001)(21056001)(105586002)(95666004)(101416001)(86362001)(93916002)(92726001)(50986999)(92566001)(53416004);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
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
index dab92a7..d1d3fc4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -610,6 +610,16 @@ F:	drivers/crypto/geode*
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
2.1.0

