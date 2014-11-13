Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaKMCDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:03:11 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:15744
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbaKMCDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:03:09 -0500
Date: Thu, 13 Nov 2014 10:10:08 +0800
From: Robin Gong <b38343@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <kernel@pengutronix.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <smoch@web.de>
Subject: Re: [PATCH v4 0/3] add power off driver for i.mx6
Message-ID: <20141113021007.GA30646@Robin-OptiPlex-780>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
 <20141112105620.GM2704@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141112105620.GM2704@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(164054003)(24454002)(21056001)(92726001)(92566001)(107046002)(104016003)(110136001)(87936001)(83506001)(84676001)(97756001)(23726002)(31966008)(33716001)(44976005)(6806004)(68736004)(120916001)(46406003)(46102003)(54356999)(50986999)(76176999)(99396003)(33656002)(50466002)(105606002)(97736003)(95666004)(20776003)(64706001)(47776003)(102836001)(4396001)(106466001)(62966003)(77156002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Shawn.
On Wed, Nov 12, 2014 at 06:56:22PM +0800, Shawn Guo wrote:
> On Wed, Nov 12, 2014 at 04:20:36PM +0800, Robin Gong wrote:
> > Resend the patchset  with the latest MAINTAINERS
> > Add simple power off driver for i.mx6, including:
> > - add basic imx-snvs-poweroff driver in drivers/power/reset
> > - add device node in all dts files of i.mx6.
> > - enable in config file
> > 
> > Change from v3:
> > - disable poweroff driver in soc level dts and enable it in board level dts
> > - replace 'EIO' with 'ENODEV' while of_iomap fail.
> > Change from v2:
> > - remove useless included head files
> > - split device binding doc from dts patch
> > - add description for the case that PMIC_ON_REQ not used as external power
> >   control
> > 
> > Robin Gong (3):
> >   ARM: dts: imx6: add pm_power_off support for i.mx6 chips
> >   power: reset: imx-snvs-poweroff: add power off driver for i.mx6
> >   ARM: configs: imx_v6_v7_defconfig: add power off driver
> 
> I'm fine with the series.  But before I take the patches, I need an ACK
> from DT folks on the bindings.
> 
> Shawn
