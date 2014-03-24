Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaCXCxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:53:03 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:7242
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbaCXCxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:53:00 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] ARM: dts: vf610-twr: Add PWM0's pinctrl node
Thread-Topic: [PATCH 2/3] ARM: dts: vf610-twr: Add PWM0's pinctrl node
Thread-Index: AQHPRAEQ//mmfX7ap0aajzxPlxxjt5rvjwUAgAAAN1A=
Date: Mon, 24 Mar 2014 02:52:56 +0000
Message-ID: <2396982097064354a789c688a96c661a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395292325-8497-1-git-send-email-Li.Xiubo@freescale.com>
 <1395292325-8497-3-git-send-email-Li.Xiubo@freescale.com>
 <20140324024818.GA10184@dragon>
In-Reply-To: <20140324024818.GA10184@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01604FB62B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(164054003)(59766001)(575784001)(76786001)(76576001)(83072002)(76796001)(63696002)(95666003)(93516002)(79102001)(74316001)(81816001)(74876001)(65816001)(33646001)(19580395003)(93136001)(47736001)(66066001)(85852003)(31966008)(20776003)(97186001)(97336001)(56816005)(81686001)(94316002)(94946001)(74366001)(74662001)(47446002)(90146001)(86362001)(19580405001)(80976001)(95416001)(92566001)(49866001)(74502001)(4396001)(2656002)(51856001)(56776001)(69226001)(76482001)(54316002)(85306002)(46102001)(54356001)(87266001)(53806001)(87936001)(81342001)(47976001)(81542001)(80022001)(50986001)(83322001)(74706001)(98676001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:7535EF6F.6CD1BD81.31C6B1CB.EA48ED9.201AA;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH 2/3] ARM: dts: vf610-twr: Add PWM0's pinctrl node
> 
> On Thu, Mar 20, 2014 at 01:12:04PM +0800, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> 
> Patch #2 and #3 can be reasonably merged into one.
> 

Yes, they are.

But the Patch #2 is a new one, not reviewed by Sascha Hauer and Yao Yuan.
I'm not sure could it be merged with Patch #3 ? Or just split them into
Two patches like this ?

Thanks,

BRs
Xiubo

> Shawn
> 
> > ---
> >  arch/arm/boot/dts/vf610-twr.dts | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-
> twr.dts
> > index f3af8ea..3fabdb5 100644
> > --- a/arch/arm/boot/dts/vf610-twr.dts
> > +++ b/arch/arm/boot/dts/vf610-twr.dts
> > @@ -213,6 +213,17 @@
> >  			>;
> >  		};
> >
> > +		pinctrl_pwm0: pwm0grp {
> > +			fsl,pins = <
> > +				VF610_PAD_PTB0__FTM0_CH0		0x1582
> > +				VF610_PAD_PTB1__FTM0_CH1		0x1582
> > +				VF610_PAD_PTB2__FTM0_CH2		0x1582
> > +				VF610_PAD_PTB3__FTM0_CH3		0x1582
> > +				VF610_PAD_PTB6__FTM0_CH6		0x1582
> > +				VF610_PAD_PTB7__FTM0_CH7		0x1582
> > +			>;
> > +		};
> > +
> >  		pinctrl_sai2: sai2grp {
> >  			fsl,pins = <
> >  				VF610_PAD_PTA16__SAI2_TX_BCLK		0x02ed
> > --
> > 1.8.4
> >
> >

