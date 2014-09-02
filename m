Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaIBJIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:08:13 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:27236
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbaIBJIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:08:10 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>, "jsarha@ti.com" <jsarha@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Shawn Guo <Shawn.Guo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: RE: [PATCHv1 4/7] ASoC: dts: kirkwood-t5325: To support simple card
 newest style.
Thread-Topic: [PATCHv1 4/7] ASoC: dts: kirkwood-t5325: To support simple card
 newest style.
Thread-Index: AQHPxaSPxtMlnd8OW0WJayJnAu1ukZvsSasAgAFFOmA=
Date: Tue, 2 Sep 2014 09:08:05 +0000
Message-ID: <e58337783d164e8da966938b27825cda@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
 <1409545781-20530-5-git-send-email-Li.Xiubo@freescale.com>
 <20140901134148.GB11312@lunn.ch>
In-Reply-To: <20140901134148.GB11312@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199003)(189002)(51704005)(377454003)(24454002)(81342001)(108616004)(99396002)(81542001)(31966008)(74316001)(74502001)(74662001)(106356001)(2656002)(77096002)(76176999)(85306004)(76482001)(66066001)(80022001)(46102001)(85852003)(101416001)(83072002)(19580395003)(87936001)(64706001)(92566001)(110136001)(105586002)(86362001)(77982001)(21056001)(106116001)(50986999)(54356999)(4396001)(90102001)(33646002)(20776003)(95666004)(83322001)(19580405001)(575784001)(107046002)(99286002)(76576001)(15866825004)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB342;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks very much for you comment and advice.

I will resend this patch series to compatibility with the old DTs, and it will
Up to the owners to update the DTs to support the new style of DTs.

BRs
Xiubo




> -----Original Message-----
> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: Monday, September 01, 2014 9:42 PM
> To: Xiubo Li-B47053
> Cc: broonie@kernel.org; lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de;
> kuninori.morimoto.gx@renesas.com; moinejf@free.fr; andrew@lunn.ch;
> jsarha@ti.com; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-sh@vger.kernel.org; alsa-devel@alsa-
> project.org; Guo Shawn-R65073; linux-kernel@vger.kernel.org; Jason Cooper
> Subject: Re: [PATCHv1 4/7] ASoC: dts: kirkwood-t5325: To support simple card
> newest style.
> 
> On Mon, Sep 01, 2014 at 12:29:38PM +0800, Xiubo Li wrote:
> > This patch depends on the following simple card patch:
> > ===
> > ASoC: simple-card: Merge single and muti DAI link code.
> 
> Saying what a patch depends on, is not the best of ChangeLog.
> 
> Say something like:
> 
> The simple-card binding has been changed, so that a dai-link subnode
> is now required, and the properties directly under the sound node are
> no longer allowed. Modify the DT to fit this new binding.
> 
>    Andrew
> 
> 
> >
> > This patch merge single DAI link and muti-DAI links code together,
> > and simply the simple-card driver code.
> >
> > And also do some other improvement:
> >
> > Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
> > mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
> > frame clock is as master/slave.
> >
> > So these same DAI formats should be informed to CPU and CODE DAIs at
> > the same time. For the Codec driver will set the bit clock and frame
> > clock as the DAI formats said, but for the CPU driver, if the the
> > bit clock or frame clock is as Codec master, so it should be set CPU
> > DAI device as bit clock or frame clock as slave, and vice versa.
> >
> > The old code will cause confusion, and we should be clear that the
> > letter 'C' here mean to Codec.
> > ===
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  arch/arm/boot/dts/kirkwood-t5325.dts | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/kirkwood-t5325.dts
> b/arch/arm/boot/dts/kirkwood-t5325.dts
> > index 610ec0f..25d1223 100644
> > --- a/arch/arm/boot/dts/kirkwood-t5325.dts
> > +++ b/arch/arm/boot/dts/kirkwood-t5325.dts
> > @@ -189,7 +189,6 @@
> >
> >  	sound {
> >  		compatible = "simple-audio-card";
> > -		simple-audio-card,format = "i2s";
> >  		simple-audio-card,routing =
> >  			"Headphone Jack", "HPL",
> >  			"Headphone Jack", "HPR",
> > @@ -204,12 +203,14 @@
> >
> >  		simple-audio-card,mclk-fs = <256>;
> >
> > -		simple-audio-card,cpu {
> > -			sound-dai = <&audio>;
> > -		};
> > -
> > -		simple-audio-card,codec {
> > -			sound-dai = <&alc5621>;
> > +		simple-audio-card,dai-link {
> > +			format = "i2s";
> > +			cpu {
> > +				sound-dai = <&audio>;
> > +			};
> > +			codec {
> > +				sound-dai = <&alc5621>;
> > +			};
> >  		};
> >  	};
> >  };
> > --
> > 1.8.4
> >
