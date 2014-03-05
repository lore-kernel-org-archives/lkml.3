Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaCEKkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:40:53 -0500
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:59386
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbaCEKku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:40:50 -0500
From: Yibin Gong <yibin.gong@freescale.com>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: pfuze100: Add PFUZE200 support to Kconfig
 and module description
Thread-Topic: [PATCH] regulator: pfuze100: Add PFUZE200 support to Kconfig
 and module description
Thread-Index: AQHPOFoZxqxeE02Uh0ekzJDeV8ZPn5rSTeYA
Date: Wed, 5 Mar 2014 10:40:47 +0000
Message-ID: <a4b5b7f13bc14787aeb930be12cc2808@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1394013763.16890.1.camel@phoenix>
In-Reply-To: <1394013763.16890.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(13464003)(377454003)(87936001)(56816005)(31966008)(87266001)(74366001)(79102001)(59766001)(77982001)(49866001)(47736001)(86362001)(90146001)(85306002)(94946001)(4396001)(47976001)(95416001)(74706001)(19580405001)(50986001)(95666003)(80976001)(94316002)(2656002)(74316001)(53806001)(51856001)(77096001)(54356001)(76576001)(69226001)(93516002)(54316002)(74876001)(76796001)(81686001)(76482001)(46102001)(81816001)(19580395003)(92566001)(81342001)(74502001)(85852003)(83322001)(76786001)(81542001)(47446002)(80022001)(83072002)(93136001)(65816001)(66066001)(33646001)(63696002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB408;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:192.88.158.215;FPR:FA5FD456.28338CDB.A05313DF.90E69B0A.201F8;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s25Af1ng014329

Acked-by: Robin Gong <b38343@freescale.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@ingics.com] 
Sent: Wednesday, March 05, 2014 6:03 PM
To: Mark Brown
Cc: Gong Yibin-B38343; Liam Girdwood; linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: pfuze100: Add PFUZE200 support to Kconfig and module description

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/Kconfig              | 6 +++---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig index 4ddfb6c..eb36d8b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -408,12 +408,12 @@ config REGULATOR_PCF50633
 	 on PCF50633
 
 config REGULATOR_PFUZE100
-	tristate "Freescale PFUZE100 regulator driver"
+	tristate "Freescale PFUZE100/PFUZE200 regulator driver"
 	depends on I2C
 	select REGMAP_I2C
 	help
-	  Say y here to support the regulators found on the Freescale PFUZE100
-	  PMIC.
+	  Say y here to support the regulators found on the Freescale
+	  PFUZE100/PFUZE200 PMIC.
 
 config REGULATOR_RC5T583
 	tristate "RICOH RC5T583 Power regulators"
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index f87ec70..67e678c 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -527,6 +527,6 @@ static struct i2c_driver pfuze_driver = {  module_i2c_driver(pfuze_driver);
 
 MODULE_AUTHOR("Robin Gong <b38343@freescale.com>"); -MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
+MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100/PFUZE200 
+PMIC");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("i2c:pfuze100-regulator");
--
1.8.1.2





ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
