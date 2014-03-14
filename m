Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaCNPpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:45:21 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:42511
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767AbaCNPpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:45:19 -0400
Date: Fri, 14 Mar 2014 21:10:59 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 06/11][SCSI]mpt2sas: Bump mpt2sas driver version to
 17.100.00.00
Message-ID: <20140314154059.GA8019@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(97756001)(19580405001)(83322001)(19580395003)(80976001)(46102001)(23726002)(44976005)(92726001)(97186001)(6806004)(97336001)(87266001)(76176001)(87936001)(36756003)(57986002)(77096001)(76786001)(85306002)(76796001)(47976001)(56816005)(50986001)(74366001)(92566001)(95416001)(54356001)(90146001)(81342001)(53806001)(50466002)(94946001)(51856001)(79102001)(81542001)(86362001)(81686001)(95666003)(4396001)(69226001)(81816001)(20776003)(47776003)(31966008)(47736001)(83072002)(74876001)(93516002)(77982001)(59766001)(94316002)(49866001)(46406003)(63696002)(76482001)(54316002)(80022001)(85852003)(65816001)(74662001)(74502001)(74706001)(56776001)(33656001)(83506001)(93136001)(16796002)(47446002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR07MB069;H:COSEXCH10.lsi.com;FPR:F4AB576B.F714B4FE.43C5CF7F.B17A8281.200F7;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt2sas driver version to 17.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

