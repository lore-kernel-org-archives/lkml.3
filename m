Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaIKRtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:49:16 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:29435
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbaIKRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:49:14 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 13:49:14 EDT
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 4/4] Update MAINTAINERS file
Date: Thu, 11 Sep 2014 12:34:24 -0500
Message-ID: <1410456864-27890-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(50466002)(62966002)(48376002)(50226001)(4396001)(102836001)(76482001)(19580405001)(105606002)(68736004)(92726001)(76176999)(44976005)(6806004)(64706001)(26826002)(74502001)(74662001)(88136002)(50986999)(106466001)(229853001)(77156001)(99396002)(87936001)(80022001)(84676001)(20776003)(47776003)(95666004)(86362001)(81542001)(36756003)(107046002)(2201001)(90102001)(19580395003)(79102001)(97736003)(87286001)(89996001)(85306004)(77982001)(31966008)(46102001)(21056001)(104166001)(81342001)(83072002)(93916002)(92566001)(83322001)(104016003)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB333;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB333;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. German Rivera" <German.Rivera@freescale.com>

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e2eb4c..eb8597d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3841,6 +3841,14 @@ S:	Maintained
 F:	sound/soc/fsl/fsl*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
+FREESCALE QORIQ MANAGEMENT COMPLEX DRIVER
+M:	J. German Rivera <German.Rivera@freescale.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/fsl_mc*
+F:	include/linux/fsl_dp*
+F:	drivers/bus/fsl-mc/*
+
 FREEVXFS FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
-- 
1.7.9.7

