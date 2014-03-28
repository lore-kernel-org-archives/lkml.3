Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaC1ELQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 00:11:16 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:9639
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752526AbaC1ELP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 00:11:15 -0400
From: Insop Song <insop.song@gainspeed.com>
To: <insop.song@gainspeed.com>, <insop.song@gmail.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] Remove warning printk
Date: Thu, 27 Mar 2014 20:54:43 -0700
Message-ID: <1395978883-18723-2-git-send-email-insop.song@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
References: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [108.60.97.2]
X-Forefront-PRVS: 01644DCF4A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(48376002)(74366001)(33646001)(81342001)(74876001)(94316002)(74706001)(69226001)(50466002)(53806001)(87286001)(95666003)(98676001)(94946001)(46102001)(56776001)(36756003)(97336001)(95416001)(89996001)(90146001)(56816005)(88136002)(86362001)(74502001)(92566001)(93916002)(92726001)(47446002)(83072002)(85852003)(93516002)(74662001)(93136001)(31966008)(85306002)(2201001)(63696002)(47776003)(20776003)(79102001)(83322001)(19580395003)(19580405001)(80976001)(49866001)(47736001)(77096001)(76786001)(65816001)(77156001)(66066001)(87936001)(81542001)(80022001)(87266001)(62966002)(4396001)(59766001)(81686001)(50986001)(47976001)(50226001)(81816001)(77982001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB116;H:BY2PRD0711HT004.namprd07.prod.outlook.com;FPR:83AED8EA.BCF31598.315F18C2.9676D6EB.200EE;MLV:sfv;PTR:InfoNoRecords;MX:1;A:3;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found from build with option -Werror=date-time

Signed-off-by: Insop Song <insop.song@gainspeed.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

