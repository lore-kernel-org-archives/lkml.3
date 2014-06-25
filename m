Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaFYKov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:44:51 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:48013
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753613AbaFYKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:44:49 -0400
Date: Wed, 25 Jun 2014 16:09:59 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 3/8][SCSI]mpt3sas: Bump mpt3sas driver version to
 03.100.00.00
Message-ID: <20140625103959.GA13008@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481666870188555;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(36756003)(76482001)(33656002)(47776003)(92726001)(81542001)(80022001)(20776003)(92566001)(74662001)(74502001)(16796002)(97756001)(99396002)(50986999)(54356999)(64706001)(31966008)(83072002)(85852003)(83506001)(86362001)(50466002)(23726002)(46102001)(81342001)(79102001)(77982001)(87936001)(102836001)(44976005)(6806004)(19580395003)(83322001)(26826002)(95666004)(85306003)(106466001)(19580405001)(105596002)(4396001)(57986006)(21056001)(46406003)(76506005)(107046001)(77096002)(42413003)(32563001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR07MB024;H:COSEXCH10.lsi.com;FPR:;MLV:ovr;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt3sas driver version to 03.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3007521..0f7add9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -70,8 +70,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"02.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		2
+#define MPT3SAS_DRIVER_VERSION		"03.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		3
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
1.7.1

