Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbbAFWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:34:49 -0500
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:63024
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbbAFWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:34:48 -0500
Date: Tue, 6 Jan 2015 16:34:10 -0600
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
Subject: Re: [PATCH v8 1/4] doc: add bindings document for altera fpga
 manager
In-Reply-To: <CAL_JsqKRe2YquSmi01wa5b=Ctns+1ek-PdSHDLuxyCfKasTw5g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1501061627150.18120@linuxheads99>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-2-git-send-email-atull@opensource.altera.com> <CAL_JsqKRe2YquSmi01wa5b=Ctns+1ek-PdSHDLuxyCfKasTw5g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0081.namprd10.prod.outlook.com (10.141.241.49) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 0448A97BF2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(24454002)(164054003)(189002)(377454003)(51704005)(50466002)(120916001)(97736003)(99396003)(1411001)(40100003)(122386002)(50986999)(4396001)(76176999)(54356999)(21056001)(68736005)(46102003)(46406003)(33716001)(87976001)(2950100001)(81156004)(83506001)(86362001)(92566001)(77156002)(110136001)(62966003)(31966008)(86152002)(23726002)(42186005)(69596002)(107046002)(53416004)(106356001)(101416001)(66066001)(19580395003)(64706001)(19580405001)(105586002)(20776003)(47776003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 22:34:37.2077 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Rob Herring wrote:

> On Tue, Jan 6, 2015 at 2:13 PM,  <atull@opensource.altera.com> wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> >
> > New bindings document for Altera fpga manager.
> >
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> Like I said, this binding doesn't look like it will change other than
> perhaps additional optional properties, so it can go into
> Documentation. Perhaps .../bindings/fpga/. I'm happy to merge this
> thru DT tree if you want.
> 
> Rob

Thanks, that would be great.  Yes ../bindings/fpga sounds good.

Do you want me to send you a patch with the updated path?

Alan

> 
> > ---
> > v5 : Move bindings to drivers/staging/fpga/Documentation/bindings
> >
> > v6 : No change in this patch for v6 of the patch set
> >
> > v7 : No change in this patch for v7 of the patch set
> >
> > v8 : Make compatible string and name of bindings doc more chip
> >      specific
> > ---
> >  .../bindings/altera-socfpga-fpga-mgr.txt           |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-socfpga-fpga-mgr.txt
> >
> > diff --git a/drivers/staging/fpga/Documentation/bindings/altera-socfpga-fpga-mgr.txt b/drivers/staging/fpga/Documentation/bindings/altera-socfpga-fpga-mgr.txt
> > new file mode 100644
> > index 0000000..9b027a6
> > --- /dev/null
> > +++ b/drivers/staging/fpga/Documentation/bindings/altera-socfpga-fpga-mgr.txt
> > @@ -0,0 +1,17 @@
> > +Altera SOCFPGA FPGA Manager
> > +
> > +Required properties:
> > +- compatible : should contain "altr,socfpga-fpga-mgr"
> > +- reg        : base address and size for memory mapped io.
> > +               - The first index is for FPGA manager register access.
> > +               - The second index is for writing FPGA configuration data.
> > +- interrupts : interrupt for the FPGA Manager device.
> > +
> > +Example:
> > +
> > +       hps_0_fpgamgr: fpgamgr@0xff706000 {
> > +               compatible = "altr,socfpga-fpga-mgr";
> > +               reg = <0xFF706000 0x1000
> > +                      0xFFB90000 0x1000>;
> > +               interrupts = <0 175 4>;
> > +       };
> > --
> > 1.7.9.5
> >
> 
