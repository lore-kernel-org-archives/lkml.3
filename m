Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaIAN2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:28:11 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:26058
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576AbaIAN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:28:08 -0400
Date: Mon, 1 Sep 2014 21:27:38 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Jason Cooper" <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "Kumar Gala" <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        "Magnus Damm" <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        "Support Opensource" <support.opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [GIT PULL] MFD: ARM (IMX & R8): Immutable branch for Dialog
 Semiconductor - vendor prefix consolidation
Message-ID: <20140901132736.GG3135@dragon>
References: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
 <20140829091359.GF24579@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829091359.GF24579@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(24454002)(189002)(51704005)(377424004)(57986006)(46102001)(54356999)(31966008)(81342001)(106466001)(83506001)(50466002)(23676002)(81156004)(69596002)(76176999)(81542001)(74662001)(95666004)(74502001)(68736004)(105606002)(104016003)(84676001)(83322001)(110136001)(19580395003)(44976005)(76482001)(50986999)(33716001)(4396001)(26826002)(87936001)(83072002)(64706001)(33656002)(79102001)(20776003)(80022001)(575784001)(77982001)(85306004)(6806004)(90102001)(102836001)(92566001)(99396002)(85852003)(97736001)(21056001)(92726001)(107046002)(86362001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Aug 29, 2014 at 10:13:59AM +0100, Lee Jones wrote:
> IMX and R8 sub-arch Maintainers,
> 
> The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> 
>   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-arm-v3.18
> 
> for you to fetch changes up to bd597f47ca4bf7a522a0298a95c7f9b2f0a75b9e:
> 
>   devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg' (2014-08-29 09:26:29 +0100)
> 
> ----------------------------------------------------------------
> Immutable branch between MFD and some ARM sub-arch maintainers.

I assume that I need to pull it into my tree only when it turns out
there are merge conflicts, but otherwise it can just go through your
tree, right?

Shawn

> ----------------------------------------------------------------
> Steve Twiss (1):
>       devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg'
> 
>  .../devicetree/bindings/i2c/trivial-devices.txt    |  2 +-
>  .../devicetree/bindings/regulator/da9210.txt       |  4 ++--
>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>  arch/arm/boot/dts/imx53-smd.dts                    |  2 +-
>  arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  2 +-
>  arch/arm/boot/dts/r8a7790-lager.dts                |  2 +-
>  arch/arm/boot/dts/r8a7791-koelsch.dts              |  2 +-
>  drivers/mfd/da9055-core.c                          | 26 +++++++++++-----------
>  8 files changed, 21 insertions(+), 20 deletions(-)
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
