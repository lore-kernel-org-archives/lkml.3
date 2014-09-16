Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaIPBni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:43:38 -0400
Received: from mail-bn1bn0107.outbound.protection.outlook.com ([157.56.110.107]:44226
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754081AbaIPBng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:43:36 -0400
Date: Tue, 16 Sep 2014 09:43:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: Robin Gong <b38343@freescale.com>, <kernel@pengutronix.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140916014304.GA23450@dragon>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <1410774073.3314.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410774073.3314.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(199003)(97756001)(76176999)(97736003)(95666004)(83072002)(86362001)(85852003)(33656002)(33716001)(83506001)(44976005)(6806004)(57986006)(74502001)(46102002)(81542002)(81342002)(80022002)(31966008)(21056001)(74662001)(90102001)(77982001)(46406003)(92566001)(50986999)(105606002)(64706001)(68736004)(110136001)(54356999)(92726001)(23726002)(102836001)(79102001)(87936001)(26826002)(106466001)(50466002)(83322001)(4396001)(84676001)(20776003)(99396002)(104016003)(85306004)(107046002)(76482001)(47776003)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB038;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:41:13AM +0200, Lucas Stach wrote:
> Am Mittwoch, den 10.09.2014, 13:30 +0800 schrieb Robin Gong:
> > There is one weird data in rxfifo after one full rx/tx transfer
> > done sometimes. It looks a design issue and hard to workaround
> > totally, so disable dma functhion here. And will re-enable it
> > once the root cause found.
> > 
> Sorry, I'm late to this as Shawn seems to already have picked up this
> patch, but this isn't the right way to fix the problem.
> 
> We made it clear at kernel summit last year that we try to not break
> existing DTs as booting a new kernel with an old DT is a valid use case.
> While you don't strictly violate this rule what you do here is only
> fixing systems booting with a new DT while leaving others broken.
> 
> If you are working around a hardware problem please disable DMA support
> in the driver. This will also allow you to enable it again, if you find
> another workaround without touching the DT again.

Okay, it's a valid point.  Patch dropped.

Shawn
