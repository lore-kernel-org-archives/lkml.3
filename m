Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbaLJR0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:26:09 -0500
Received: from mail-bn1bon0058.outbound.protection.outlook.com ([157.56.111.58]:61376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757021AbaLJR0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:26:07 -0500
Date: Wed, 10 Dec 2014 11:25:59 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 2/6] arm: dts: socfpga: add altera fpga manager
In-Reply-To: <20141210150109.GA23358@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1412101123530.25868@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-3-git-send-email-atull@opensource.altera.com> <20141210150109.GA23358@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA060.namprd06.prod.outlook.com (10.141.250.178) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 0421BF7135
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(199003)(51704005)(50986999)(76176999)(54356999)(68736005)(66066001)(97736003)(40100003)(64706001)(47776003)(20776003)(86362001)(86152002)(62966003)(77156002)(122386002)(92566001)(31966008)(15975445007)(101416001)(23726002)(4396001)(87976001)(33716001)(99396003)(81156004)(106356001)(50466002)(120916001)(105586002)(69596002)(107046002)(19580405001)(46406003)(19580395003)(53416004)(21056001)(42186005)(83506001)(110136001)(46102003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0602;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Steffen Trumtrar wrote:

> Hi!
> 
> On Tue, Dec 09, 2014 at 02:14:46PM -0600, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add Altera FGPA manager to device tree.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  arch/arm/boot/dts/socfpga.dtsi |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > index 4472fd9..bab98b6 100644
> > --- a/arch/arm/boot/dts/socfpga.dtsi
> > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > @@ -751,5 +751,15 @@
> >  			compatible = "altr,sys-mgr", "syscon";
> >  			reg = <0xffd08000 0x4000>;
> >  		};
> > +
> > +		hps_0_fpgamgr: fpgamgr@0xff706000 {
> > +			compatible = "altr,fpga-mgr", "simple-bus";
> > +			reg = <0xFF706000 0x1000
> > +			       0xFFB90000 0x1000>;
> > +			interrupts = <0 175 4>;
> > +			#address-cells = <1>;
> > +			#size-cells = <1>;
> > +			ranges;
> > +		};
> 
> The fpgamgr is NOT a bus. You don't need ranges and/or simple-bus.
> 
> Regards,
> Steffen

Actually, I am going to be using this when I add the DT notification 
stuff.  That stuff is waiting for DT overlays to show up in the main
tree.

So the choice it to either change this file now, once, or do the minimal 
changes and have to change it again later.

Alan

> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
