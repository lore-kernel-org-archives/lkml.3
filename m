Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaDDJxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:53:00 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:58095
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752439AbaDDJww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:52:52 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: RE: [PATCH v2 2/2] ARM: dts: Append clock bindings for sai2 on
 VF610 platform
Thread-Topic: [PATCH v2 2/2] ARM: dts: Append clock bindings for sai2 on
 VF610 platform
Thread-Index: AQHPTlukgmr0/pW6C0WbBlkEfNifiZr+Sw0AgAAKTACAAuO8sA==
Date: Fri, 4 Apr 2014 09:52:48 +0000
Message-ID: <1ce55f756ee04609a2d8ea1f14ad1f3f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1396432924.git.Guangyu.Chen@freescale.com>
 <d09da3eb629143abd3f61ae037af4ddaf7286a83.1396432924.git.Guangyu.Chen@freescale.com>
 <20140402130302.GC8558@dragon> <20140402133955.GB29440@MrMyself>
In-Reply-To: <20140402133955.GB29440@MrMyself>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(164054003)(94946001)(95416001)(81342001)(80976001)(87266001)(85852003)(99396002)(99286001)(69226001)(81686001)(94316002)(46102001)(81816001)(74876001)(47446002)(74662001)(93516002)(86362001)(81542001)(97186001)(95666003)(65816001)(80022001)(56816005)(93136001)(90146001)(2656002)(66066001)(87936001)(83072002)(97336001)(98676001)(19580405001)(83322001)(74316001)(76786001)(63696002)(76796001)(51856001)(54356001)(85306002)(76482001)(74366001)(54316002)(56776001)(77982001)(59766001)(76576001)(20776003)(74706001)(47736001)(49866001)(33646001)(79102001)(50986001)(74502001)(4396001)(47976001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB443;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:2CDAF256.8F29D08.F1E11649.CEE0FA91.203A0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH v2 2/2] ARM: dts: Append clock bindings for sai2 on VF610
> platform
> 
> Hi Shawn,
> 
>    Thanks for the comments, but...
> 
> On Wed, Apr 02, 2014 at 09:03:04PM +0800, Shawn Guo wrote:
> > On Wed, Apr 02, 2014 at 06:10:20PM +0800, Nicolin Chen wrote:
> > > Since we added fours clock to the DT binding, we should update the current
> > > SAI dts/dtsi so as not to break their functions.
> > >
> > > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > > ---
> > >  arch/arm/boot/dts/vf610.dtsi | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > > index d31ce1b..9fd0007 100644
> > > --- a/arch/arm/boot/dts/vf610.dtsi
> > > +++ b/arch/arm/boot/dts/vf610.dtsi
> > > @@ -139,8 +139,10 @@
> > >  				compatible = "fsl,vf610-sai";
> > >  				reg = <0x40031000 0x1000>;
> > >  				interrupts = <0 86 0x04>;
> > > -				clocks = <&clks VF610_CLK_SAI2>;
> > > -				clock-names = "sai";
> > > +				clocks = <&clks VF610_CLK_SAI2>,
> > > +				       <&clks VF610_CLK_SAI2>,
> > > +				       <&clks 0>, <&clks 0>;
> >
> > So it seems that SAI on vf610 does work with only one clock.  So the
> > driver change will break old DTB for vf610?  If that's case, we will
> > have to need a new compatible for cases where 4 clocks are needed.
> 
> According to Vybrid's RM Chapter 9.11.12 SAI clocking, the SoC actually
> connects SAI with two clocks: SAI_CLK and Platform Bus Clock. So the DT
> binding here still needs to be corrected even if ignoring driver change.
> 
> Besides, I've checked both SAI on imx and vf610 and found that they are
> seemly identical, especially for the clock part -- "The transmitter and
> receiver can independently select between the bus clock and up to three
> audio master clocks to generate the bit clock." And the driver that was
> designed for vf610 already contains the code to switch the clock between
> Bus Clock and Three MCLKs. What I want to say is, even if SAI on vf610
> does work with only one clock, it still doesn't have the full function
> on vf610 -- driving clock from Platform Bus Clock unless we make this
> improvement to the DT binding.
> 
> So I think it's fair to complete the code here for both platforms, even
> though we might take the risk of merging conflict. And I understand
> your point to avoid function break on those platform both of us aren't
> convenient to test. But I've already involved Xiubo in the list. And
> we can wait for his test result.
> 

This has been test on my Vybird-TWR board and it's fine.

Thanks,

Brs
Xiubo



> Hope you can understand the circumstance,
> Nicolin

