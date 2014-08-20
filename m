Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaHTAyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:54:49 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:48413
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbaHTAym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:54:42 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 4/4 v2] Update MAINTAINERS file
Date: Tue, 19 Aug 2014 19:54:30 -0500
Message-ID: <1408496070-6252-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408496070-6252-1-git-send-email-German.Rivera@freescale.com>
References: <1408496070-6252-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(50226001)(4396001)(76176999)(104016003)(97736001)(69596002)(93916002)(68736004)(89996001)(44976005)(50986999)(83322001)(95666004)(106466001)(79102001)(105606002)(87286001)(86362001)(104166001)(81342001)(6806004)(80022001)(107046002)(84676001)(74662001)(83072002)(47776003)(76482001)(21056001)(92566001)(85852003)(26826002)(92726001)(2201001)(88136002)(48376002)(229853001)(46102001)(36756003)(31966008)(50466002)(85306004)(99396002)(81156004)(81542001)(77156001)(102836001)(19580395003)(74502001)(64706001)(20776003)(19580405001)(87936001)(62966002)(77982001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB325;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03094A4065
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. German Rivera" <German.Rivera@freescale.com>

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
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

