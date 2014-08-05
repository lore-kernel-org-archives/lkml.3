Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaHEPcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:32:22 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:47731
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755564AbaHEPcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:32:19 -0400
X-WSS-ID: 0N9UB5J-08-R1B-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 06/23] Update MAINTAINERS and CREDITS files with amdkfd info
Date: Tue, 5 Aug 2014 18:30:34 +0300
Message-ID: <1407252651-3539-7-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(84676001)(50466002)(87936001)(104166001)(62966002)(83072002)(86362001)(101416001)(92726001)(88136002)(92566001)(83322001)(19580405001)(95666004)(87286001)(79102001)(23676002)(19580395003)(107046002)(77096002)(89996001)(4396001)(77156001)(85852003)(50226001)(81342001)(31966008)(97736001)(21056001)(105586002)(36756003)(33646002)(99396002)(106466001)(68736004)(229853001)(77982001)(64706001)(46102001)(76176999)(74502001)(44976005)(20776003)(81542001)(74662001)(47776003)(76482001)(102836001)(80022001)(85306004)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
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
index 28ee151..e9628d5 100644
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
index d76e077..da3aecb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -589,6 +589,16 @@ F:	drivers/crypto/geode*
 F:	drivers/video/geode/
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

