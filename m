Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaFYKlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:41:31 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:34359
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756571AbaFYKl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:41:29 -0400
Date: Wed, 25 Jun 2014 16:06:40 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 10/10][SCSI]mpt2sas: Bump mpt2sas driver version to
 18.100.00.00
Message-ID: <20140625103640.GA12969@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481664671083523;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(85306003)(47776003)(85852003)(83072002)(64706001)(20776003)(106466001)(86362001)(31966008)(80022001)(87936001)(74502001)(16796002)(79102001)(81542001)(92566001)(19580395003)(92726001)(83322001)(6806004)(19580405001)(44976005)(77096002)(107046001)(105596002)(57986006)(23726002)(95666004)(76506005)(46406003)(76482001)(33656002)(102836001)(26826002)(83506001)(99396002)(50466002)(81342001)(97756001)(4396001)(50986999)(74662001)(36756003)(54356999)(46102001)(21056001)(77982001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB028;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt2sas driver version to 18.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 6dbbaba..cc49cbf 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,8 +69,8 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"17.100.00.00"
-#define MPT2SAS_MAJOR_VERSION		17
+#define MPT2SAS_DRIVER_VERSION		"18.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		18
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
 #define MPT2SAS_RELEASE_VERSION		00
-- 
1.7.1

