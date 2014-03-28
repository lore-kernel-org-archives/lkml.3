Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaC1IK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:10:58 -0400
Received: from [207.46.163.205] ([207.46.163.205]:38296 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751376AbaC1IKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:10:43 -0400
From: Insop Song <insop.song@gainspeed.com>
To: <insop.song@gainspeed.com>, <insop.song@gmail.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <arnd@arndb.de>
Subject: [PATCH] Remove warning printk
Date: Fri, 28 Mar 2014 01:09:21 -0700
Message-ID: <1395994161-19967-1-git-send-email-insop.song@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [157.56.241.101]
X-ClientProxiedBy: SN2PR07CA007.namprd07.prod.outlook.com (10.255.174.24) To
 BLUPR07MB004.namprd07.prod.outlook.com (10.255.209.38)
X-Forefront-PRVS: 01644DCF4A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(46102001)(53806001)(56776001)(19580405001)(19580395003)(51856001)(54316002)(42186004)(47446002)(74502001)(66066001)(65816001)(80022001)(36756003)(76176001)(74706001)(74876001)(62966002)(81542001)(31966008)(69226001)(74662001)(81342001)(47976001)(50226001)(50986001)(98676001)(77982001)(59766001)(74366001)(47736001)(97186001)(49866001)(85852003)(93136001)(33646001)(4396001)(79102001)(97336001)(50466002)(94946001)(76786001)(47776003)(63696002)(20776003)(77156001)(77096001)(76796001)(95666003)(48376002)(95416001)(80976001)(92726001)(92566001)(85306002)(83072002)(2201001)(81686001)(83322001)(89996001)(88136002)(90146001)(87976001)(81816001)(56816005)(87266001)(87286001)(86362001)(93916002)(94316002)(93516002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB004;H:BL2PRD0810HT005.namprd08.prod.outlook.com;FPR:83BAD8EA.BCF30598.F15F28C2.9676D6E3.200DB;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found from build with option -Werror=date-time

Signed-off-by: Insop Song <insop.song@gainspeed.com>
---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 89bc84d..7506900 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -373,7 +373,6 @@ static int __init gs_fpgaboot_init(void)
 	r = -1;
 
 	pr_info("FPGA DOWNLOAD --->\n");
-	pr_info("built at %s UTC\n", __TIMESTAMP__);
 
 	pr_info("FPGA image file name: %s\n", file);
 
-- 
1.7.9.5

