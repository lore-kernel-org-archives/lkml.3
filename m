Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaCNQQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:16:18 -0400
Received: from [207.46.163.190] ([207.46.163.190]:47078 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755367AbaCNQQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:16:15 -0400
Date: Fri, 14 Mar 2014 21:41:37 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 4/9][SCSI]mpt3sas: Bump mpt3sas driver version to
 v03.100.00.00
Message-ID: <20140314161137.GA8373@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(56776001)(92726001)(95416001)(54316002)(69226001)(86362001)(93516002)(47776003)(83322001)(93136001)(20776003)(53806001)(81342001)(44976005)(51856001)(54356001)(19580395003)(81542001)(76482001)(19580405001)(81686001)(46102001)(80976001)(81816001)(77982001)(63696002)(47736001)(79102001)(87266001)(92566001)(74706001)(23726002)(31966008)(16796002)(47446002)(74502001)(74662001)(6806004)(74366001)(50986001)(87936001)(97336001)(56816005)(85852003)(95666003)(83072002)(97186001)(77096001)(47976001)(57986002)(76796001)(65816001)(46406003)(94316002)(59766001)(90146001)(36756003)(4396001)(83506001)(74876001)(50466002)(49866001)(85306002)(76786001)(76176001)(80022001)(33656001)(97756001)(94946001)(42413003)(32563001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB386;H:COSEXCH10.lsi.com;CLIP:192.19.220.100;FPR:FCAB776A.3714B4DF.43C4CF7F.B17A9E81.200F6;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt3sas driver version to 03.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

