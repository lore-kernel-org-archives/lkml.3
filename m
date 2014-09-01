Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaIAOgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:36:02 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:14720
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbaIAOf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:35:59 -0400
Date: Mon, 1 Sep 2014 22:35:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnaud Ebalard <arno@natisbad.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jonathan Cameron <jic23@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        LINUX SH <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Mark Brown <broonie@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Fuzzey <mfuzzey@parkeon.com>, Pawel Moll <pawel.moll@arm.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Simon Horman <horms@verge.net.au>,
        Support Opensource <support.opensource@diasemi.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [GIT PULL] MFD: ARM (IMX & R8): Immutable branch for Dialog
 Semiconductor - vendor prefix consolidation
Message-ID: <20140901143517.GH3135@dragon>
References: <201408221446.s7MEkNVF001775@swsrvapps-01.diasemi.com>
 <20140829091359.GF24579@lee--X1> <20140901132736.GG3135@dragon>
 <20140901133854.GA8796@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140901133854.GA8796@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(377424004)(189002)(24454002)(51704005)(95666004)(44976005)(68736004)(107046002)(81342001)(110136001)(23726002)(50466002)(80022001)(84676001)(69596002)(54356999)(92726001)(106466001)(93886004)(77982001)(92566001)(81542001)(105606002)(20776003)(85306004)(99396002)(74662001)(102836001)(33656002)(74502001)(104016003)(85852003)(21056001)(31966008)(33716001)(79102001)(97756001)(83506001)(6806004)(81156004)(575784001)(26826002)(19580395003)(83322001)(76482001)(64706001)(4396001)(97736001)(90102001)(86362001)(57986006)(47776003)(46406003)(87936001)(46102001)(50986999)(76176999)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB562;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 02:38:54PM +0100, Lee Jones wrote:
> On Mon, 01 Sep 2014, Shawn Guo wrote:
> > On Fri, Aug 29, 2014 at 10:13:59AM +0100, Lee Jones wrote:
> > > IMX and R8 sub-arch Maintainers,
> > > 
> > > The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
> > > 
> > >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-arm-v3.18
> > > 
> > > for you to fetch changes up to bd597f47ca4bf7a522a0298a95c7f9b2f0a75b9e:
> > > 
> > >   devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg' (2014-08-29 09:26:29 +0100)
> > > 
> > > ----------------------------------------------------------------
> > > Immutable branch between MFD and some ARM sub-arch maintainers.
> > 
> > I assume that I need to pull it into my tree only when it turns out
> > there are merge conflicts, but otherwise it can just go through your
> > tree, right?
> 
> If someone realises there's a conflict the chances are we've already
> hacked someone off.  If the first person to realise is Linus during
> the merge-window, you'd have to go to the effort of re-spinning your
> pull-request.  Something else you'd probably like to avoid.

I think if there is a conflict, linux-next will firstly report.  But,
yes, pulling it in is the safest.
> 
> I would suggest for each affected Maintainer to pull this in.

Pulled it into imx/dt branch, thanks.

Shawn
