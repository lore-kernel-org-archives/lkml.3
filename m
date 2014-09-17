Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIQHLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:11:21 -0400
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:38407
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbaIQHLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:11:20 -0400
Date: Wed, 17 Sep 2014 15:17:38 +0800
From: Robin Gong <b38343@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@freescale.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917071736.GA5545@Robin-OptiPlex-780>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
 <20140917021044.GD4796@dragon> <20140917034514.GF27452@Robin-OptiPlex-780>
 <20140917060649.GJ4992@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917060649.GJ4992@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(24454002)(199003)(83322001)(20776003)(110136001)(54356999)(19580395003)(15202345003)(85852003)(107046002)(23726002)(97756001)(105606002)(95666004)(15975445006)(92726001)(90102001)(93886004)(83072002)(64706001)(46406003)(33716001)(83506001)(104016003)(97736003)(99396002)(85306004)(6806004)(4396001)(87936001)(92566001)(46102003)(74502003)(31966008)(81342003)(74662003)(80022003)(50466002)(77982003)(21056001)(47776003)(76176999)(50986999)(26826002)(68736004)(84676001)(76482002)(102836001)(81542003)(79102003)(106466001)(33656002)(44976005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB347;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB347;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:06:49AM +0200, Sascha Hauer wrote:
> On Wed, Sep 17, 2014 at 11:45:15AM +0800, Robin Gong wrote:
> > On Wed, Sep 17, 2014 at 10:10:45AM +0800, Shawn Guo wrote:
> > > On Fri, Sep 12, 2014 at 04:48:57PM +0800, Robin Gong wrote:
> > > > All chips of i.mx6 can be powered off by programming SNVS.
> > > > For example :
> > > > On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> > > > pmic ON/OFF pin, that will cause the whole PMIC powered off
> > > > except VSNVS. And system can restart once PMIC_ON_REQ goes
> > > > high by push POWRER key.
> > > 
> > > What's the behavior for those boards on which PMIC_ON_REQ isn't
> > > connected to anywhere?
> > >
> > System can't be powered off if not connect PMIC_ON_REQ. Although all of our
> > reference design for i.mx6 chips are connecting  PMIC_ON_REQ with external
> > PMIC, we need consider others may not use external PMIC. I'll add the info
> > into commit log or Kconfig.
> 
> You should add the information to the dtsi file in form of a
> status = "disabled" property so that boards that actually have the
> feature can enable it.
> 
> Sascha
Hi Sacha, but that's  SOC level feature and it's harmless even if others don't
want to use this pin to control external PMIC.
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
