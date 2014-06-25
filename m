Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbaFYKqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:46:45 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:43766
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754090AbaFYKqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:46:44 -0400
Date: Wed, 25 Jun 2014 16:12:07 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to
 04.100.00.00
Message-ID: <20140625104207.GA13042@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481668009895054;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(99396002)(95666004)(46102001)(54356999)(76482001)(81542001)(83506001)(50986999)(21056001)(4396001)(97756001)(74502001)(74662001)(16796002)(31966008)(33656002)(102836001)(83072002)(85852003)(19580395003)(44976005)(83322001)(19580405001)(6806004)(23726002)(107046001)(36756003)(50466002)(106466001)(105596002)(79102001)(77982001)(80022001)(57986006)(47776003)(20776003)(64706001)(76506005)(77096002)(46406003)(85306003)(81342001)(26826002)(86362001)(92566001)(87936001)(92726001)(42413003)(32563001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB026;H:COSEXCH10.lsi.com;FPR:;MLV:ovr;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt3sas driver version to 04.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8fb2a38..09545fc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -70,8 +70,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"03.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		3
+#define MPT3SAS_DRIVER_VERSION		"04.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		4
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
1.7.1

