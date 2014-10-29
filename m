Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaJ2Uqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:46:53 -0400
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:6368
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755312AbaJ2Uqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:46:51 -0400
Date: Wed, 29 Oct 2014 15:39:43 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
In-Reply-To: <20141029082440.GA22891@amd>
Message-ID: <alpine.DEB.2.02.1410291537540.29374@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de> <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
 <20141029082440.GA22891@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR04CA0045.eurprd04.prod.outlook.com (10.242.87.163) To
 DM2PR03MB319.namprd03.prod.outlook.com (10.141.54.18)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB319;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(51704005)(24454002)(80022003)(53416004)(122386002)(107046002)(97736003)(95666004)(46406003)(15975445006)(106356001)(15202345003)(69596002)(76482002)(120916001)(66066001)(81156004)(105586002)(93886004)(50466002)(101416001)(85306004)(92726001)(46102003)(83506001)(23726002)(20776003)(40100003)(31966008)(21056001)(86152002)(33716001)(92566001)(19580395003)(47776003)(50986999)(85852003)(87976001)(42186005)(86362001)(64706001)(77096002)(76176999)(110136001)(4396001)(99396003)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB319;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Pavel Machek wrote:

> Hi!
> 
> > > > +Optional properties:
> > > > + - label          : name that you want this bridge to show up as under
> > > > +                    /sys/class/fpga-bridge.  Default is br<device#> if this is
> > > > +                    not specified.
> > > > +
> > > 
> > > Why? Linux-specific.
> > 
> > That was a convience for the user.  I can take that out and won't
> > miss it.
> 
> Actually make it
> 
> - label : optional user-readable name for this bridge
> 
> ...and it is no longer Linux-specific, and you can keep it if it is
> otherwise useful...
> 									Pavel

Great!  Thanks for the review.  In the future I'll keep my sysfs 
documentation separate from my DT bindings!

Alan

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
