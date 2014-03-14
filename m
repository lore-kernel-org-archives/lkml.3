Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaCNQTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:19:52 -0400
Received: from [207.46.163.210] ([207.46.163.210]:13475 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755797AbaCNQTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:19:51 -0400
Date: Fri, 14 Mar 2014 21:44:43 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 9/9][SCSI]mpt3sas: Bump mpt3sas driver version to
 v04.100.00.00
Message-ID: <20140314161443.GA8421@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(74876001)(33656001)(50466002)(74706001)(23726002)(74366001)(46406003)(85306002)(87266001)(53806001)(76482001)(87936001)(54356001)(6806004)(51856001)(46102001)(56776001)(54316002)(97756001)(81816001)(47976001)(50986001)(49866001)(4396001)(19580405001)(81686001)(80976001)(83322001)(19580395003)(47736001)(83506001)(44976005)(95666003)(90146001)(63696002)(79102001)(77982001)(97336001)(59766001)(97186001)(20776003)(80022001)(65816001)(47776003)(85852003)(93516002)(93136001)(36756003)(83072002)(76176001)(57986002)(86362001)(92566001)(92726001)(47446002)(74502001)(81342001)(56816005)(95416001)(77096001)(74662001)(81542001)(69226001)(76796001)(16796002)(31966008)(94316002)(76786001)(94946001)(42413003)(32563001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR07MB071;H:COSEXCH10.lsi.com;FPR:FCAB774A.4714B4DF.43C4CF77.B07A9281.200FA;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump mpt3sas driver version to 04.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

