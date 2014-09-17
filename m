Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaIQJMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:12:53 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:9284
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751852AbaIQJMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:12:51 -0400
Date: Wed, 17 Sep 2014 17:19:24 +0800
From: Robin Gong <b38343@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140917091922.GA6551@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <1410774073.3314.1.camel@pengutronix.de>
 <20140916034123.GA20800@Robin-OptiPlex-780>
 <1410861006.2746.1.camel@pengutronix.de>
 <20140917084120.GA6369@Robin-OptiPlex-780>
 <1410944156.2731.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410944156.2731.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(51704005)(189002)(15202345003)(93886004)(50466002)(95666004)(64706001)(26826002)(83072002)(105606002)(85306004)(47776003)(110136001)(46102003)(23726002)(99396002)(46406003)(81342003)(31966008)(104016003)(4396001)(54356999)(90102001)(97736003)(44976005)(102836001)(79102003)(50986999)(87936001)(21056001)(83322001)(20776003)(85852003)(76176999)(81542003)(33656002)(33716001)(74662003)(68736004)(6806004)(83506001)(106466001)(84676001)(15975445006)(76482002)(107046002)(19580395003)(92726001)(80022003)(92566001)(97756001)(74502003)(77982003)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB337;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB337;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:55:56AM +0200, Lucas Stach wrote:
> Am Mittwoch, den 17.09.2014, 16:41 +0800 schrieb Robin Gong:
> > On Tue, Sep 16, 2014 at 11:50:06AM +0200, Lucas Stach wrote:
> > > Hi Robin,
> > > 
> > > Am Dienstag, den 16.09.2014, 11:41 +0800 schrieb Robin Gong:
> > > > Hi Lucas,
> > > >   I understood your concern,but looks we have to break old DT.
> > > 
> > > Sorry, but this isn't going to happen. And honestly I don't even see the
> > > need to do so.
> > > 
> > > > Our old DT
> > > > support SPI DMA on i.mx6q/dl(v2,b3810c3dc1bcbc6a), but the DMA support patch
> > > > for SPI driver is still in reviewing(v6).
> > > 
> > > So this means now is the time to fix this driver patch to not enable DMA
> > > on imx6dl. Nobody will experience any breakage in this case.
> > >
> > Sorry, i.mx6q and i.mx6dl are totally same, not only IP but also clock. So we
> > can't distinguish them except for different compatible name....
> 
> I know that, but I still don't see the problem.
> 
> If this issue is specific to the ECSPI IP integrated into a imx6dl SoC
> you need to check for the machine compatible in the driver and disable
> DMA support based on this. We generally avoid checking for the machine
> compatible in drivers and prefer to have a specific IP block compatible
> instead, but in that case it's the only reasonable thing to do.
> 
> Regards,
> Lucas
Sounds we make a agreement on use different compatible name, right? I will
make patch for reviewing, thanks.
> -- 
> Pengutronix e.K.             | Lucas Stach                 |
> Industrial Linux Solutions   | http://www.pengutronix.de/  |
> 
