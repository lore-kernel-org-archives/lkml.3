Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDDCJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:09:22 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:41809
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbaDDCJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:09:17 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Topic: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
Thread-Index: AQHPTt69R9PCJUUK7UW+0eH2KtDmx5sAF94AgACOdvCAAAw2gIAABUqA
Date: Fri, 4 Apr 2014 02:09:14 +0000
Message-ID: <45be66f717074e4b85c5fc531e05045f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396487059-15298-1-git-send-email-Li.Xiubo@freescale.com>
 <1396487059-15298-3-git-send-email-Li.Xiubo@freescale.com>
 <20140403163604.GA11832@roeck-us.net>
 <6563b26412a7457ba38e2dcf0bdcb643@BY2PR03MB505.namprd03.prod.outlook.com>
 <533E0FB3.6070305@roeck-us.net>
In-Reply-To: <533E0FB3.6070305@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(54316002)(56816005)(90146001)(74706001)(47446002)(51856001)(87266001)(76576001)(74316001)(74366001)(74502001)(74662001)(31966008)(74876001)(56776001)(87936001)(76482001)(46102001)(76796001)(95666003)(95416001)(81342001)(94316002)(83072002)(81686001)(81542001)(80022001)(97186001)(97336001)(66066001)(65816001)(33646001)(69226001)(85852003)(93516002)(99396002)(94946001)(98676001)(47736001)(49866001)(54356001)(2656002)(50986001)(53806001)(83322001)(47976001)(80976001)(99286001)(81816001)(77982001)(59766001)(92566001)(93136001)(86362001)(85306002)(20776003)(79102001)(63696002)(4396001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:4A53F022.4028C19.A8E880A0.47C6AEB9.20129;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is caused by not compiling the regmap core.
> >
> > Could you add the following patch to have a try ?
> > ==========================
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 79d2589..3e55fa9 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -369,6 +369,7 @@ config MAX63XX_WATCHDOG
> >   config IMX2_WDT
> >          tristate "IMX2+ Watchdog"
> >          depends on ARCH_MXC
> > +       select REGMAP_MMIO
> >          help
> >            This is the driver for the hardware watchdog
> >            on the Freescale IMX2 and later processors.
> > --------------------------
> >
> > If it's okey, I'll sent the v5 series to fix this.
> >
> Yes, that fixes the problem.
> 


I'll send the v5 series to fix this.

Thanks very much.
