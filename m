Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaHWEJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 00:09:46 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:17862
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbaHWEJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 00:09:44 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 4/4 v3] Update MAINTAINERS file
Date: Fri, 22 Aug 2014 23:09:37 -0500
Message-ID: <1408766977-2283-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1408766977-2283-1-git-send-email-German.Rivera@freescale.com>
References: <1408766977-2283-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(21056001)(74662001)(107046002)(99396002)(79102001)(64706001)(81342001)(50986999)(46102001)(84676001)(47776003)(74502001)(6806004)(88136002)(50466002)(90102001)(85306004)(106466001)(83322001)(68736004)(48376002)(77982001)(50226001)(80022001)(93916002)(19580405001)(77156001)(62966002)(2201001)(31966008)(86362001)(36756003)(229853001)(87936001)(89996001)(92566001)(95666004)(4396001)(26826002)(102836001)(104016003)(105606002)(76176999)(85852003)(19580395003)(76482001)(92726001)(104166001)(20776003)(81542001)(83072002)(44976005)(87286001)(97736001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB324;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031257FE13
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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

