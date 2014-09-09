Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaIIBh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:37:27 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:27318
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754676AbaIIBh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:37:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>, "mpa@pengutronix.de" <mpa@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
 endianness method.
Thread-Topic: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
 endianness method.
Thread-Index: AQHPwDpuCOL/HMzK6EOO8Uq1kEa2JJvyMIWAgACVxwCABVZIsA==
Date: Tue, 9 Sep 2014 01:37:22 +0000
Message-ID: <7f0ca96002794780b7ff98269bb05c89@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408953277-2069-1-git-send-email-Li.Xiubo@freescale.com>
 <54446636ab294eed83c4a4e3d405dfe7@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140905160640.GB12374@roeck-us.net>
In-Reply-To: <20140905160640.GB12374@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(199003)(189002)(377454003)(164054003)(24454002)(13464003)(51704005)(108616004)(79102001)(74316001)(64706001)(80022001)(33646002)(90102001)(76482001)(31966008)(110136001)(97736003)(74502001)(74662001)(99286002)(15202345003)(19580395003)(77982001)(83322001)(81542001)(85852003)(15975445006)(19580405001)(95666004)(4396001)(86362001)(107046002)(92566001)(81342001)(66066001)(83072002)(105586002)(21056001)(20776003)(76576001)(85306004)(87936001)(77096002)(2656002)(76176999)(50986999)(54356999)(106356001)(106116001)(101416001)(46102001)(99396002)(24736002)(422495003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Get it.

Thanks very much.

BRs
Xiubo




> -----Original Message-----
> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter Roeck
> Sent: Saturday, September 06, 2014 12:07 AM
> To: Xiubo Li-B47053
> Cc: wim@iguana.be; mpa@pengutronix.de; linux-watchdog@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org
> Subject: Re: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
> endianness method.
> 
> On Fri, Sep 05, 2014 at 07:11:31AM +0000, Li.Xiubo@freescale.com wrote:
> > Hi,
> >
> > Ping :)
> >
> Wim usually picks up patches shortly before the next release window opens.
> 
> It is in my watchdog-next branch, so it is not forgotten. I'll send a pull
> request to Wim after -rc5.
> 
> Wim, I am wondering - should I ask Stephen to add my watchdog-next branch to
> linux-next ? I know it isn't really perfect, and there is no guarantee that
> you will accept the patches in my branch, but it would expose the pending
> patches to earlier visibility in -next.
> 
> Thanks,
> Guenter
> 
> > Thanks,
> >
> > BRs
> > Xiubo
> >
> >
> > > -----Original Message-----
> > > From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> > > Sent: Monday, August 25, 2014 3:55 PM
> > > To: wim@iguana.be; linux@roeck-us.net; mpa@pengutronix.de; linux-
> > > watchdog@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Xiubo Li-
> B47053
> > > Subject: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
> > > endianness method.
> > >
> > > Regmap framework will contain some patches to handle endianess, and there
> > > does not need any parsing of endianness DT properties of individual driver,
> > > so we can savely remove it here.
> > >
> > > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > Cc: Markus Pargmann <mpa@pengutronix.de>
> > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >
> > > Changes in v2:
> > > - Remove useless header file.
> > >
> > >
> > >
> > >
> > >  Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt | 4 ++--
> > >  drivers/watchdog/imx2_wdt.c                                | 9 +--------
> > >  2 files changed, 3 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > > b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > > index e52ba2d..9e1ebe2 100644
> > > --- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > > +++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > > @@ -6,8 +6,8 @@ Required properties:
> > >  - interrupts : Should contain WDT interrupt
> > >
> > >  Optional property:
> > > -- big-endian: If present the watchdog device's registers are implemented
> > > -  in big endian mode, otherwise in little mode.
> > > +- big-endian: Boolean property, required if all the i.MX WDT registers
> > > +  are big-endian rather than little-endian.
> > >
> > >  Examples:
> > >
> > > diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> > > index 68c3d37..afc8738 100644
> > > --- a/drivers/watchdog/imx2_wdt.c
> > > +++ b/drivers/watchdog/imx2_wdt.c
> > > @@ -28,7 +28,6 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/module.h>
> > >  #include <linux/moduleparam.h>
> > > -#include <linux/of_address.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/regmap.h>
> > >  #include <linux/timer.h>
> > > @@ -182,7 +181,7 @@ static struct watchdog_ops imx2_wdt_ops = {
> > >  	.set_timeout = imx2_wdt_set_timeout,
> > >  };
> > >
> > > -static struct regmap_config imx2_wdt_regmap_config = {
> > > +static const struct regmap_config imx2_wdt_regmap_config = {
> > >  	.reg_bits = 16,
> > >  	.reg_stride = 2,
> > >  	.val_bits = 16,
> > > @@ -191,12 +190,10 @@ static struct regmap_config imx2_wdt_regmap_config =
> {
> > >
> > >  static int __init imx2_wdt_probe(struct platform_device *pdev)
> > >  {
> > > -	struct device_node *np = pdev->dev.of_node;
> > >  	struct imx2_wdt_device *wdev;
> > >  	struct watchdog_device *wdog;
> > >  	struct resource *res;
> > >  	void __iomem *base;
> > > -	bool big_endian;
> > >  	int ret;
> > >  	u32 val;
> > >
> > > @@ -204,10 +201,6 @@ static int __init imx2_wdt_probe(struct
> platform_device
> > > *pdev)
> > >  	if (!wdev)
> > >  		return -ENOMEM;
> > >
> > > -	big_endian = of_property_read_bool(np, "big-endian");
> > > -	if (big_endian)
> > > -		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> > > -
> > >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > >  	base = devm_ioremap_resource(&pdev->dev, res);
> > >  	if (IS_ERR(base))
> > > --
> > > 1.8.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
