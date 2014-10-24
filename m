Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaJXPSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:18:18 -0400
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:14211
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751391AbaJXPSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:18:14 -0400
Date: Fri, 24 Oct 2014 10:11:26 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>, <rob@landley.net>,
        <davem@davemloft.net>, <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, <linus.walleij@linaro.org>,
        <mgerlach@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 1/3] add sysfs document for fpga bridges
In-Reply-To: <20141024105420.GB20775@amd>
Message-ID: <alpine.DEB.2.02.1410241009010.23446@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-2-git-send-email-atull@opensource.altera.com> <20141024105420.GB20775@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR09CA0013.namprd09.prod.outlook.com (25.160.223.23) To
 BY2PR03MB313.namprd03.prod.outlook.com (10.141.139.13)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB313;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(51704005)(199003)(377424004)(50944004)(189002)(19580395003)(19580405001)(15975445006)(83506001)(69596002)(20776003)(21056001)(86152002)(64706001)(86362001)(92566001)(92726001)(87976001)(77096002)(85852003)(31966008)(110136001)(102836001)(53416004)(95666004)(105586002)(81156004)(120916001)(101416001)(99396003)(97736003)(42186005)(106356001)(107046002)(46102003)(80022003)(76482002)(23726002)(122386002)(33716001)(46406003)(54356999)(50986999)(50466002)(66066001)(85306004)(4396001)(40100003)(76176999)(15202345003)(3556765001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB313;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Pavel Machek wrote:

> On Thu 2014-10-23 18:51:05, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add sysfs document for fpga bridges.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  Documentation/ABI/testing/sysfs-class-fpga-bridge |    5 +++++
> >  1 file changed, 5 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-bridge
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-fpga-bridge b/Documentation/ABI/testing/sysfs-class-fpga-bridge
> > new file mode 100644
> > index 0000000..b3303ae
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-fpga-bridge
> > @@ -0,0 +1,5 @@
> > +What:		/sys/class/fpga-bridge/<bridge>/enable
> > +Date:		October 2014
> > +KernelVersion:	3.18
> > +Contact:	Alan Tull <atull@opensource.altera.com>
> > +Description:	Enable bridge.  Write 1 to bring bridge out of reset.
> 
> Specify, what happens when 0 is written there?
> 									Pavel

Yes, I will add:  'Write 0 has no effect.'

Alan

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
