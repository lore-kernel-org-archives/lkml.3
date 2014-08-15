Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaHOWNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:13:47 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:50036
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751377AbaHOWNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:13:45 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 4/4] Update MAINTAINERS file
Date: Fri, 15 Aug 2014 17:13:14 -0500
Message-ID: <1408140794-25064-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(76482001)(77982001)(74502001)(2201001)(68736004)(84676001)(4396001)(69596002)(99396002)(81542001)(88136002)(79102001)(46102001)(74662001)(87286001)(62966002)(95666004)(47776003)(83322001)(107046002)(26826002)(31966008)(97736001)(19580405001)(19580395003)(80022001)(89996001)(229853001)(85306004)(81156004)(83072002)(50986999)(106466001)(86362001)(104016003)(21056001)(92566001)(44976005)(50226001)(48376002)(104166001)(93916002)(64706001)(92726001)(77156001)(87936001)(102836001)(85852003)(50466002)(6806004)(20776003)(76176999)(105606002)(36756003)(81342001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0742;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
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

