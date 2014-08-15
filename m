Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaHOWYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:24:35 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:54852
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbaHOWYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:24:34 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <stuart.yoder@freescale.com>
CC: <linux-kernel@vger.kernel.org>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 4/4] Update MAINTAINERS file
Date: Fri, 15 Aug 2014 17:09:37 -0500
Message-ID: <1408140577-24982-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408140577-24982-1-git-send-email-German.Rivera@freescale.com>
References: <1408140577-24982-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(79102001)(86362001)(93916002)(26826002)(85306004)(76482001)(4396001)(47776003)(62966002)(68736004)(83072002)(102836001)(74662001)(97736001)(50466002)(74502001)(84676001)(69596002)(46102001)(76176999)(6806004)(80022001)(104166001)(48376002)(99396002)(229853001)(104016003)(2351001)(92726001)(95666004)(89996001)(81542001)(44976005)(31966008)(92566001)(77156001)(77982001)(2371004)(50986999)(106466001)(36756003)(87286001)(83322001)(50226001)(19580405001)(87936001)(81156004)(110136001)(20776003)(81342001)(88136002)(85852003)(19580395003)(64706001)(107046002)(21056001)(105606002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB336;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

