Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab3LIIc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:32:27 -0500
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:53771
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760702Ab3LIIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:32:24 -0500
From: "yibin.gong@freescale.com" <yibin.gong@freescale.com>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: pfuze100: Fix address of FABID
Thread-Topic: [PATCH] regulator: pfuze100: Fix address of FABID
Thread-Index: AQHO9K/Bq9cBMeRZHEuGPTP6jt8RzJpLiL3A
Date: Mon, 9 Dec 2013 08:32:21 +0000
Message-ID: <92b2d00a0ca849d2a81b0ba90554a4fc@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1386573859.5508.0.camel@phoenix>
In-Reply-To: <1386573859.5508.0.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(377454003)(13464003)(199002)(189002)(65816001)(47446002)(79102001)(76576001)(46102001)(53806001)(76796001)(33646001)(77096001)(63696002)(69226001)(31966008)(83072001)(76786001)(74502001)(56776001)(54316002)(47736001)(50986001)(47976001)(74706001)(76482001)(80976001)(74316001)(87266001)(74366001)(85306002)(81686001)(2656002)(56816005)(87936001)(90146001)(80022001)(59766001)(74662001)(77982001)(66066001)(4396001)(81816001)(81542001)(54356001)(51856001)(19580405001)(19580395003)(83322001)(85852002)(74876001)(81342001)(49866001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB036;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB98WWl9003633

Acked-by: Robin Gong <b38343@freescale.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@ingics.com] 
Sent: Monday, December 09, 2013 3:24 PM
To: Mark Brown
Cc: Gong Yibin-B38343; Liam Girdwood; linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: pfuze100: Fix address of FABID

According to the datasheet, the address of FABID is 0x4. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 032df37..8b5e4c7 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -38,7 +38,7 @@
 
 #define PFUZE100_DEVICEID	0x0
 #define PFUZE100_REVID		0x3
-#define PFUZE100_FABID		0x3
+#define PFUZE100_FABID		0x4
 
 #define PFUZE100_SW1ABVOL	0x20
 #define PFUZE100_SW1CVOL	0x2e
-- 
1.8.1.2





ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
