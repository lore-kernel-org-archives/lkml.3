Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCTC5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:57:51 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:52164
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750757AbaCTC5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:57:48 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 22:57:48 EDT
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        "Mark Rutland" <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Budig <simon.budig@kernelconcepts.de>
Subject: RE: [PATCHv4 1/5] Input: edt-ft5x06: several cleanups; no
 functional change
Thread-Topic: [PATCHv4 1/5] Input: edt-ft5x06: several cleanups; no
 functional change
Thread-Index: AQHPQ3SJJktDdwwSA0KMaWvo2kmAuprpRInA
Date: Thu, 20 Mar 2014 02:42:25 +0000
Message-ID: <5f82f6ff3c38443f86f4a55c8d435712@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
 <1395234563-11034-2-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1395234563-11034-2-git-send-email-LW@KARO-electronics.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377454003)(51704005)(47446002)(74502001)(69226001)(74662001)(85306002)(80022001)(81342001)(66066001)(80976001)(79102001)(46102001)(2656002)(31966008)(59766001)(33646001)(74706001)(54356001)(94946001)(76482001)(53806001)(54316002)(94316002)(74366001)(74316001)(95416001)(20776003)(87266001)(63696002)(575784001)(86362001)(76576001)(77982001)(95666003)(19580395003)(76786001)(83322001)(56776001)(76796001)(81542001)(74876001)(19580405001)(65816001)(90146001)(4396001)(51856001)(87936001)(81816001)(93136001)(2201001)(85852003)(97336001)(92566001)(97186001)(83072002)(93516002)(47736001)(50986001)(47976001)(49866001)(56816005)(81686001)(1121002)(921003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB375;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:BC2B427E.F7F29C0B.25E75B5F.10EACAB2.20318;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2K2w0hr018540

From: Lothar WaÃŸmann <LW@KARO-electronics.de>
Data: Wednesday, March 19, 2014 9:09 PM

>To: Dmitry Torokhov; Duan Fugang-B38611; Grant Likely; Henrik Rydberg; Ian
>Campbell; Jingoo Han; Kumar Gala; Mark Rutland; Pawel Moll; Rob Herring; Rob
>Landley; Sachin Kamat; devicetree@vger.kernel.org; linux-doc@vger.kernel.org;
>linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Simon Budig; Lothar
>WaÃŸmann
>Subject: [PATCHv4 1/5] Input: edt-ft5x06: several cleanups; no functional
>change
>
>- remove redundant parens
>- remove redundant type casts
>- fix mixed tab/space indentation
>
>Signed-off-by: Lothar WaÃŸmann <LW@KARO-electronics.de>
>---
> drivers/input/touchscreen/edt-ft5x06.c |   12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/input/touchscreen/edt-ft5x06.c
>b/drivers/input/touchscreen/edt-ft5x06.c
>index 412a85e..7b4470d 100644
>--- a/drivers/input/touchscreen/edt-ft5x06.c
>+++ b/drivers/input/touchscreen/edt-ft5x06.c
>@@ -173,7 +173,7 @@ static irqreturn_t edt_ft5x06_ts_isr(int irq, void *dev_id)
> 		x = ((buf[0] << 8) | buf[1]) & 0x0fff;
> 		y = ((buf[2] << 8) | buf[3]) & 0x0fff;
> 		id = (buf[2] >> 4) & 0x0f;
>-		down = (type != TOUCH_EVENT_UP);
>+		down = type != TOUCH_EVENT_UP;
>
> 		input_mt_slot(tsdata->input, id);
> 		input_mt_report_slot_state(tsdata->input, MT_TOOL_FINGER, down);
>@@ -257,7 +257,7 @@ static ssize_t edt_ft5x06_setting_show(struct device *dev,
> 	struct edt_ft5x06_ts_data *tsdata = i2c_get_clientdata(client);
> 	struct edt_ft5x06_attribute *attr =
> 			container_of(dattr, struct edt_ft5x06_attribute, dattr);
>-	u8 *field = (u8 *)((char *)tsdata + attr->field_offset);
>+	u8 *field = (u8 *)tsdata + attr->field_offset;
> 	int val;
> 	size_t count = 0;
> 	int error = 0;
>@@ -299,7 +299,7 @@ static ssize_t edt_ft5x06_setting_store(struct device *dev,
> 	struct edt_ft5x06_ts_data *tsdata = i2c_get_clientdata(client);
> 	struct edt_ft5x06_attribute *attr =
> 			container_of(dattr, struct edt_ft5x06_attribute, dattr);
>-	u8 *field = (u8 *)((char *)tsdata + attr->field_offset);
>+	u8 *field = (u8 *)tsdata + attr->field_offset;
> 	unsigned int val;
> 	int error;
>
>@@ -479,7 +479,7 @@ static int edt_ft5x06_debugfs_mode_set(void *data, u64 mode)
>
> 	if (mode != tsdata->factory_mode) {
> 		retval = mode ? edt_ft5x06_factory_mode(tsdata) :
>-			        edt_ft5x06_work_mode(tsdata);
>+				edt_ft5x06_work_mode(tsdata);
> 	}
>
> 	mutex_unlock(&tsdata->mutex);
>@@ -852,8 +852,8 @@ static SIMPLE_DEV_PM_OPS(edt_ft5x06_ts_pm_ops,
> 			 edt_ft5x06_ts_suspend, edt_ft5x06_ts_resume);
>
> static const struct i2c_device_id edt_ft5x06_ts_id[] = {
>-	{ "edt-ft5x06", 0 },
>-	{ }
>+	{ "edt-ft5x06", 0, },
>+	{ /* sentinel */ }
> };
> MODULE_DEVICE_TABLE(i2c, edt_ft5x06_ts_id);
>
>--
>1.7.10.4
>
>

Acked-by: Fugang Duan <B38611@freescale.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
