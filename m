Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaCNPtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:49:53 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:2955
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753707AbaCNPtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:49:52 -0400
Date: Fri, 14 Mar 2014 21:15:30 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 11/11][SCSI]mpt2sas: Bump mpt2sas driver version to
 18.100.00.00
Message-ID: <20140314154530.GA8075@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(59766001)(81542001)(83506001)(47446002)(51856001)(36756003)(79102001)(6806004)(46406003)(85852003)(76482001)(56776001)(95666003)(81686001)(83072002)(74502001)(54316002)(54356001)(77982001)(81816001)(94946001)(19580395003)(69226001)(63696002)(20776003)(19580405001)(83322001)(33656001)(57986002)(90146001)(74662001)(50466002)(76786001)(4396001)(87266001)(92566001)(86362001)(74876001)(74366001)(46102001)(47976001)(93136001)(50986001)(93516002)(92726001)(47736001)(65816001)(74706001)(95416001)(85306002)(53806001)(31966008)(80976001)(94316002)(56816005)(87936001)(81342001)(97186001)(47776003)(97336001)(76176001)(77096001)(23726002)(44976005)(80022001)(49866001)(97756001)(76796001)(16796002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB388;H:COSEXCH10.lsi.com;CLIP:192.19.220.100;FPR:F4AB576B.F716B4EE.4FC4CF7F.B17A8101.200F4;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt2sas driver version to 18.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

