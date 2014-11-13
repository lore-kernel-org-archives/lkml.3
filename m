Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbaKMUit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:38:49 -0500
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:49431
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932684AbaKMUis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:38:48 -0500
X-WSS-ID: 0NEZW0J-07-QXV-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Joe Perches <joe@perches.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        John Bridgman <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jean Delvare <khali@linux-fr.org>, Christoph Lameter <cl@gentwo.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Sebastian Reichel <sre@debian.org>,
        "David S. Miller" <davem@davemloft.net>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v6 06/24] Update MAINTAINERS and CREDITS files with amdkfd info
Date: Thu, 13 Nov 2014 22:38:01 +0200
Message-ID: <1415911096-16577-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(36756003)(64706001)(47776003)(105586002)(68736004)(106466001)(53416004)(20776003)(50466002)(44976005)(19580395003)(19580405001)(99396003)(120916001)(46102003)(33646002)(107046002)(50986999)(102836001)(104166001)(77096003)(62966003)(93916002)(101416001)(89996001)(23676002)(88136002)(92566001)(87286001)(87936001)(86362001)(92726001)(77156002)(97736003)(21056001)(4396001)(95666004)(50226001)(110136001)(84676001)(229853001)(31966008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v6: Update entries to reflect new name & location of driver

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
index ea4d005..3c69a3c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -618,6 +618,16 @@ S:	Maintained
 F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
+AMD KFD
+M:      Oded Gabbay <oded.gabbay@amd.com>
+L:      dri-devel@lists.freedesktop.org
+T:      git git://people.freedesktop.org/~gabbayo/linux.git
+S:      Supported
+F:      drivers/gpu/drm/amd/amdkfd/
+F:      drivers/gpu/drm/radeon/radeon_kfd.c
+F:      drivers/gpu/drm/radeon/radeon_kfd.h
+F:      include/uapi/linux/kfd_ioctl.h
+
 AMD MICROCODE UPDATE SUPPORT
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	amd64-microcode@amd64.org
-- 
2.1.0

