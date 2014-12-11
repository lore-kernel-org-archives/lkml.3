Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056AbaLKQFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:05:52 -0500
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:55104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932739AbaLKQFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:05:49 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2014 11:05:48 EST
Date: Thu, 11 Dec 2014 09:50:02 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Michal Simek <michal.simek@xilinx.com>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
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
In-Reply-To: <d9903a1dee0343c083dc7ec04a70ff99@BN1BFFO11FD015.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412110947430.25919@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-3-git-send-email-atull@opensource.altera.com> <20141210150109.GA23358@pengutronix.de> <alpine.DEB.2.02.1412101123530.25868@linuxheads99> <20141210174945.GC23358@pengutronix.de>
 <d9903a1dee0343c083dc7ec04a70ff99@BN1BFFO11FD015.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0004.namprd00.prod.outlook.com (25.160.102.14) To
 CY1PR0301MB1244.namprd03.prod.outlook.com (25.161.212.154)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:CY1PR0301MB1244;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(51704005)(479174003)(199003)(164054003)(377454003)(122386002)(31966008)(53416004)(46406003)(33716001)(68736005)(110136001)(76176999)(42186005)(40100003)(50466002)(23726002)(93886004)(120916001)(99396003)(77156002)(97736003)(62966003)(19580395003)(19580405001)(69596002)(101416001)(21056001)(105586002)(83506001)(87976001)(92566001)(86152002)(4396001)(66066001)(81156004)(50986999)(54356999)(106356001)(46102003)(20776003)(107046002)(86362001)(47776003)(64706001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1244;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014, Michal Simek wrote:

> On 12/10/2014 06:49 PM, Steffen Trumtrar wrote:
> > On Wed, Dec 10, 2014 at 11:25:59AM -0600, atull wrote:
> >> On Wed, 10 Dec 2014, Steffen Trumtrar wrote:
> >>
> >>> Hi!
> >>>
> >>> On Tue, Dec 09, 2014 at 02:14:46PM -0600, atull@opensource.altera.com wrote:
> >>>> From: Alan Tull <atull@opensource.altera.com>
> >>>>
> >>>> Add Altera FGPA manager to device tree.
> >>>>
> >>>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >>>> ---
> >>>>  arch/arm/boot/dts/socfpga.dtsi |   10 ++++++++++
> >>>>  1 file changed, 10 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> >>>> index 4472fd9..bab98b6 100644
> >>>> --- a/arch/arm/boot/dts/socfpga.dtsi
> >>>> +++ b/arch/arm/boot/dts/socfpga.dtsi
> >>>> @@ -751,5 +751,15 @@
> >>>>  			compatible = "altr,sys-mgr", "syscon";
> >>>>  			reg = <0xffd08000 0x4000>;
> >>>>  		};
> >>>> +
> >>>> +		hps_0_fpgamgr: fpgamgr@0xff706000 {
> >>>> +			compatible = "altr,fpga-mgr", "simple-bus";
> >>>> +			reg = <0xFF706000 0x1000
> >>>> +			       0xFFB90000 0x1000>;
> >>>> +			interrupts = <0 175 4>;
> >>>> +			#address-cells = <1>;
> >>>> +			#size-cells = <1>;
> >>>> +			ranges;
> >>>> +		};
> >>>
> >>> The fpgamgr is NOT a bus. You don't need ranges and/or simple-bus.
> >>>
> >>> Regards,
> >>> Steffen
> >>
> >> Actually, I am going to be using this when I add the DT notification 
> >> stuff.  That stuff is waiting for DT overlays to show up in the main
> >> tree.
> >>
> >> So the choice it to either change this file now, once, or do the minimal 
> >> changes and have to change it again later.
> >>
> > 
> > Yes, that is what I thought. And still, devices can NOT show up
> > at the fpgamgr. They show up on the various bridges.
> > 
> > And as far as I understand the DT overlay stuff, you specify in
> > the overlay what the parent node will be.
> > For i2c this is one of the i2c-hosts, for spi one of the spi-hosts
> > and for IP cores in a bitstream one of the bridges.
> > 
> > The fpgamgr is, from my understanding, only responsible for writing
> > the bitstream to the FPGA; nothing more.
> 
> +1 on this.
> I think you can easily decide later where DT overlays will be added.
> 
> Thanks,
> Michal
> 
> 

OK guys, I'll simplify it down to the following in v5:

 +                hps_0_fpgamgr: fpgamgr@0xff706000 {
 +                        compatible = "altr,fpga-mgr";
 +                        reg = <0xFF706000 0x1000
 +                               0xFFB90000 0x1000>;
 +                        interrupts = <0 175 4>;
 +                };

Alan
