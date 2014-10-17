Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaJQIFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:05:30 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:64384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbaJQIFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:05:18 -0400
Date: Fri, 17 Oct 2014 16:12:02 +0800
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@linaro.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] add power off driver for i.mx6
Message-ID: <20141017081200.GB6691@Robin-OptiPlex-780>
References: <1411703947-31956-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411703947-31956-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(189002)(84676001)(102836001)(83506001)(47776003)(20776003)(85852003)(64706001)(6806004)(19580405001)(104016003)(15202345003)(85306004)(69596002)(46406003)(21056001)(4396001)(33656002)(87936001)(92726001)(50466002)(2201001)(31966008)(92566001)(33716001)(26826002)(105606002)(106466001)(81156004)(95666004)(97736003)(107046002)(97756001)(76482002)(54356999)(15975445006)(68736004)(76176999)(44976005)(80022003)(120916001)(99396003)(23726002)(46102003)(50986999)(19580395003)(921003)(1121002)(2101003)(42262002)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0633;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!
On Fri, Sep 26, 2014 at 11:59:04AM +0800, Robin Gong wrote:
> Add simple power off driver for i.mx6, including:
> - add basic imx-snvs-poweroff driver in drivers/power/reset
> - add device node in all dts files of i.mx6.
> - enable in config file
> 
> Change from v3:
> - disable poweroff driver in soc level dts and enable it in board level dts
> - replace 'EIO' with 'ENODEV' while of_iomap fail.
> Change from v2:
> - remove useless included head files
> - split device binding doc from dts patch
> - add description for the case that PMIC_ON_REQ not used as external power
>   control
> 
> Robin Gong (3):
>   ARM: dts: imx6: add pm_power_off support for i.mx6 chips
>   power: reset: imx-snvs-poweroff: add power off driver for i.mx6
>   ARM: configs: imx_v6_v7_defconfig: add power off driver
> 
>  arch/arm/boot/dts/imx6qdl.dtsi          |  5 +++
>  arch/arm/boot/dts/imx6sl.dtsi           |  5 +++
>  arch/arm/boot/dts/imx6sx.dtsi           |  5 +++
>  arch/arm/configs/imx_v6_v7_defconfig    |  3 ++
>  drivers/power/reset/Kconfig             |  5 +++
>  drivers/power/reset/Makefile            |  1 +
>  drivers/power/reset/imx-snvs-poweroff.c | 69 +++++++++++++++++++++++++++++++++
>  7 files changed, 93 insertions(+)
>  create mode 100644 drivers/power/reset/imx-snvs-poweroff.c
> 
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
