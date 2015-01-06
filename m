Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbbAFQFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:05:30 -0500
Received: from mail-bn1bon0068.outbound.protection.outlook.com ([157.56.111.68]:63568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755498AbbAFQF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:05:27 -0500
Date: Tue, 6 Jan 2015 10:04:49 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Rob Herring <robherring2@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>, Mark Brown <broonie@kernel.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v7 1/4] doc: add bindings document for altera fpga
 manager
In-Reply-To: <CAL_Jsq+bwnA14RALT9WWZ=wzt7akjPOJ8s5878CcgkU4EDRC4Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1501061001520.1089@linuxheads99>
References: <1419007551-10040-1-git-send-email-atull@opensource.altera.com> <1419007551-10040-2-git-send-email-atull@opensource.altera.com> <CAL_Jsq+bwnA14RALT9WWZ=wzt7akjPOJ8s5878CcgkU4EDRC4Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR01CA060.prod.exchangelabs.com (25.160.23.50) To
 BY1PR0301MB1237.namprd03.prod.outlook.com (25.161.203.21)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1237;
X-Forefront-PRVS: 0448A97BF2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(377454003)(189002)(199003)(51704005)(4396001)(47776003)(64706001)(20776003)(23726002)(97736003)(40100003)(122386002)(120916001)(99396003)(19580405001)(19580395003)(83506001)(69596002)(1411001)(46102003)(33716001)(86362001)(46406003)(87976001)(31966008)(21056001)(92566001)(66066001)(42186005)(86152002)(53416004)(54356999)(76176999)(50986999)(81156004)(50466002)(110136001)(68736005)(106356001)(77156002)(62966003)(105586002)(107046002)(2950100001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1237;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 16:05:18.1949 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014, Rob Herring wrote:

> On Fri, Dec 19, 2014 at 10:45 AM,  <atull@opensource.altera.com> wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> >
> > New bindings document for Altera fpga manager.
> >
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> > v5 : Move bindings to drivers/staging/fpga/Documentation/bindings
> >
> > v6 : No change in this patch for v6 of the patch set
> >
> > v7 : No change in this patch for v7 of the patch set
> > ---
> >  .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> >
> > diff --git a/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> > new file mode 100644
> > index 0000000..373af7b
> > --- /dev/null
> > +++ b/drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> > @@ -0,0 +1,17 @@
> > +Altera FPGA Manager
> > +
> > +Required properties:
> > +- compatible : should contain "altr,fpga-mgr"
> > +- reg        : base address and size for memory mapped io.
> > +               - The first index is for FPGA manager register access.
> > +               - The second index is for writing FPGA configuration data.
> > +- interrupts : interrupt for the FPGA Manager device.
> > +
> > +Example:
> > +
> > +       hps_0_fpgamgr: fpgamgr@0xff706000 {
> > +               compatible = "altr,fpga-mgr";
> 
> Is "FPGA Manager" what the block is called or the name for the Linux
> subsystem?" The name should reflect the h/w block name. Also, is the
> block the same in every chip?

I see what you are saying.  The subsystem is 'fpga manager'.

I should change this to "altr,socfpga-fpga-mgr" so that it is the
fpga manager block that is specific to SOCFPGA chips.  Also I should
change the filename of the binding document accordingly.

> 
> This binding doesn't look complex or likely to change, so it can be
> out of staging unless you expect it to change.
> 
> Rob
> 
