Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaGNGEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:04:16 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:19305
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752717AbaGNGEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:04:12 -0400
Date: Mon, 14 Jul 2014 14:04:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, <wg@grandegger.com>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
Message-ID: <20140714060344.GB2197@dragon>
References: <1405075933-22317-1-git-send-email-stefan@agner.ch>
 <53BFD401.8030101@pengutronix.de> <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(189002)(199002)(57704003)(51704005)(24454002)(83506001)(107046002)(81342001)(77982001)(21056001)(33716001)(76482001)(20776003)(80022001)(97736001)(64706001)(104016003)(81542001)(47776003)(33656002)(50466002)(74502001)(105606002)(4396001)(83072002)(86362001)(57986006)(26826002)(110136001)(87936001)(6806004)(97756001)(19580405001)(69596002)(85852003)(106466001)(102836001)(95666004)(92726001)(92566001)(81156004)(23726002)(54356999)(76176999)(84676001)(31966008)(74662001)(50986999)(46406003)(83322001)(46102001)(68736004)(99396002)(79102001)(85306003)(44976005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB381;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:58:37PM +0200, Stefan Agner wrote:
> >> @@ -362,7 +374,7 @@
> >>
> >>  			esdhc1: esdhc@400b2000 {
> >>  				compatible = "fsl,imx53-esdhc";
> >> -				reg = <0x400b2000 0x4000>;
> >> +				reg = <0x400b2000 0x1000>;
> > 
> > What's that doing here? :)
> 
> That's an error I just stumbled upon.

I do not see why it's an error.  From Table 2-1. System Memory Map in
i.MX53 RM, the size of ESDHC1 is 16K.

Shawn

> I know it's not related but it's
> such a small change... Do I need to make a separate patch for that or
> can I include it in the FlexCAN dt commit?
