Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592AbaICWoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:44:23 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:21087
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933473AbaICWoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:44:19 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 4/4 v4] Update MAINTAINERS file
Date: Wed, 3 Sep 2014 17:25:46 -0500
Message-ID: <1409783146-13418-5-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1409783146-13418-1-git-send-email-German.Rivera@freescale.com>
References: <1409783146-13418-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(105606002)(87936001)(104166001)(64706001)(80022001)(81156004)(92726001)(79102001)(2201001)(92566001)(26826002)(88136002)(19580405001)(83322001)(19580395003)(77982001)(68736004)(69596002)(44976005)(6806004)(81342001)(229853001)(47776003)(107046002)(81542001)(62966002)(20776003)(95666004)(106466001)(89996001)(90102001)(36756003)(99396002)(77156001)(97736001)(50986999)(93916002)(86362001)(21056001)(104016003)(50466002)(48376002)(85852003)(46102001)(85306004)(83072002)(102836001)(4396001)(50226001)(76176999)(76482001)(31966008)(87286001)(74662001)(84676001)(74502001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB326;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. German Rivera" <German.Rivera@freescale.com>

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes in v4:
none

Changes in v3:
none

Changes in v2:
none

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

