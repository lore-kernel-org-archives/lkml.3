Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaFYKhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:37:41 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:35364
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755372AbaFYKhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:37:39 -0400
Date: Wed, 25 Jun 2014 16:03:13 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 05/10][SCSI]mpt2sas: Bump mpt2sas driver version to
 17.100.00.00
Message-ID: <20140625103313.GA12921@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481662547248673;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(33656002)(26826002)(92726001)(81542001)(36756003)(46406003)(50986999)(105596002)(107046001)(106466001)(54356999)(76506005)(57986006)(77096002)(85306003)(4396001)(102836001)(50466002)(21056001)(99396002)(95666004)(83506001)(79102001)(74662001)(16796002)(31966008)(86362001)(87936001)(23726002)(47776003)(20776003)(92566001)(97756001)(6806004)(46102001)(44976005)(64706001)(81342001)(19580395003)(83322001)(19580405001)(77982001)(83072002)(85852003)(74502001)(76482001)(80022001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB020;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt2sas driver version to 17.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 80d26c1..0a6747a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,8 +69,8 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"16.100.00.00"
-#define MPT2SAS_MAJOR_VERSION		16
+#define MPT2SAS_DRIVER_VERSION		"17.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		17
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
 #define MPT2SAS_RELEASE_VERSION		00
-- 
1.7.1

