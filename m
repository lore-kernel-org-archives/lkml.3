Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaDCFDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 01:03:10 -0400
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22353 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaDCFC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 01:02:59 -0400
From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 02/55] scsi: Mark function as static in
 be2iscsi/be_cmds.c
Thread-Topic: [PATCH 02/55] scsi: Mark function as static in
 be2iscsi/be_cmds.c
Thread-Index: AQHPS3ZfxvrI6WL7pEejRAM6EE1pl5r/W6+w
Date: Thu, 3 Apr 2014 05:02:57 +0000
Message-ID: <37724B2049F71D4C9B086F99DDB2DE11570D083C@CMEXMB1.ad.emulex.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <e8c6c765e48ea867376850f1bc693f797fa14a53.1396114897.git.rashika.kheria@gmail.com>
In-Reply-To: <e8c6c765e48ea867376850f1bc693f797fa14a53.1396114897.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.125.170]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3353Y3E015501

Looks good

Acked-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---

-----Original Message-----
From: Rashika Kheria [mailto:rashika.kheria@gmail.com] 
Sent: Saturday, March 29, 2014 10:44 AM
To: linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal; James E.J. Bottomley; linux-scsi@vger.kernel.org; josh@joshtriplett.org
Subject: [PATCH 02/55] scsi: Mark function as static in be2iscsi/be_cmds.c

Mark function as static in be2iscsi/be_cmds.c because it is not used outside this file.

This eliminates the following warning in be2iscsi/be_cmds.c:
drivers/scsi/be2iscsi/be_cmds.c:401:5: warning: no previous prototype for â€˜beiscsi_process_mccâ€™ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c index 3338391..026c3e3 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -398,7 +398,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,  }
 
 
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+static int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num = 0, status = 0;
--
1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
