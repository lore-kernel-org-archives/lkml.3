Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaC1EKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 00:10:21 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:47504
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751236AbaC1EKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 00:10:19 -0400
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 00:10:19 EDT
From: Insop Song <insop.song@gainspeed.com>
To: <insop.song@gainspeed.com>, <insop.song@gmail.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro
Date: Thu, 27 Mar 2014 20:54:42 -0700
Message-ID: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [108.60.97.2]
X-Forefront-PRVS: 01644DCF4A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(48376002)(74366001)(33646001)(81342001)(74876001)(94316002)(74706001)(69226001)(50466002)(53806001)(87286001)(95666003)(98676001)(94946001)(46102001)(56776001)(36756003)(97336001)(95416001)(89996001)(90146001)(56816005)(88136002)(86362001)(74502001)(92566001)(93916002)(92726001)(47446002)(83072002)(85852003)(93516002)(74662001)(93136001)(31966008)(85306002)(2201001)(63696002)(47776003)(20776003)(79102001)(83322001)(80976001)(558084003)(49866001)(47736001)(77096001)(76786001)(65816001)(77156001)(66066001)(87936001)(81542001)(80022001)(87266001)(62966002)(76176001)(4396001)(59766001)(81686001)(50986001)(47976001)(50226001)(81816001)(77982001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB116;H:BY2PRD0711HT004.namprd07.prod.outlook.com;FPR:F1F25AFE.BC39499A.D0D4882F.FF0CD4C1.2004F;MLV:sfv;PTR:InfoNoRecords;MX:1;A:3;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove warning

Insop Song (1):
  Remove warning printk

 drivers/staging/gs_fpgaboot/gs_fpgaboot.c |    1 -
 1 file changed, 1 deletion(-)

-- 
1.7.9.5

