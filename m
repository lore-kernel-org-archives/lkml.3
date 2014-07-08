Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaGHFTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:19:31 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:40858
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbaGHFT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:19:29 -0400
Date: Tue, 8 Jul 2014 13:19:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sachin Kamat <spk.linux@gmail.com>
CC: Fabian Frederick <fabf@skynet.be>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: imx: use PTR_ERR_OR_ZERO
Message-ID: <20140708051916.GB26257@dragon>
References: <1404500590-21712-1-git-send-email-fabf@skynet.be>
 <20140707055521.GM30239@dragon>
 <CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK5sBcE2xxb1NGegn1L_CFH27vzx8kLg06u9fVTo6SZk8_6qJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(189002)(377454003)(51704005)(26826002)(105606002)(46102001)(97736001)(97756001)(92726001)(21056001)(102836001)(99396002)(81542001)(46406003)(81342001)(68736004)(77982001)(6806004)(19580405001)(54356999)(44976005)(19580395003)(83322001)(79102001)(64706001)(86362001)(95666004)(33716001)(92566001)(106466001)(50466002)(104016002)(110136001)(20776003)(47776003)(33656002)(31966008)(83072002)(85852003)(74502001)(107046002)(74662001)(81156004)(80022001)(69596002)(87936001)(4396001)(57986006)(50986999)(84676001)(76176999)(83506001)(76482001)(23726002)(85306003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB375;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:18:56AM +0530, Sachin Kamat wrote:
> Hi Shawn,
> 
> On Mon, Jul 7, 2014 at 11:25 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > On Fri, Jul 04, 2014 at 09:03:10PM +0200, Fabian Frederick wrote:
> >> replace IS_ERR/PTR_ERR
> >>
> >> Cc: Shawn Guo <shawn.guo@freescale.com>
> >> Cc: Sascha Hauer <kernel@pengutronix.de>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >
> > Applied, thanks.
> 
> 
> I had sent a similar series [1] in May which you rejected. Just
> curious if something
> changed between then and now?

The main difference is this is the second attempt from a different
person to "clean up" the code.  I'm still not fond of the change, but
I'm getting tied to tell people about that, so just applied the change,
since after all it at least gives some good diffstat.

I would prefer Fabian's patch over yours because it's really good
enough to have one patch than 5 patches in a series to do the change for
IMX platform.

Shawn
