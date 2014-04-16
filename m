Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaDPJik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:38:40 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:31662
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751227AbaDPJig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:38:36 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Topic: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Index: AQHPWSBaHNmWFeafwkKQ+QxFukJEhZsT9H2AgAAIWbA=
Date: Wed, 16 Apr 2014 09:38:33 +0000
Message-ID: <ac0038bd2f9142119cfe5843afbf78e9@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
 <534E4873.5070308@linaro.org>
In-Reply-To: <534E4873.5070308@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(479174003)(377454003)(164054003)(51704005)(24454002)(189002)(199002)(83072002)(83322001)(76482001)(86362001)(80022001)(46102001)(85852003)(74662001)(19580395003)(19580405001)(15395725003)(76176999)(99286001)(92566001)(77096999)(77982001)(54356999)(2201001)(50986999)(99396002)(80976001)(74502001)(4396001)(81342001)(81542001)(87936001)(76576001)(79102001)(33646001)(20776003)(2656002)(31966008)(74316001)(66066001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB382;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:F87DFA76.3BB19ED5.6E6D6B37.8CEE969E.201E4;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3G9cnUE002133

> Subject: Re: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module
> timer node.
> 
> On 04/16/2014 04:19 AM, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: Jingchang Lu <b35083@freescale.com>
> 
> That deserves a patch description and an update of the documentation.
>

Yes, I'll add this.


Thanks,

BRs
Xiubo

 
> Thanks
>    -- Daniel
> 
> > ---
> >   arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index 107e2c0..c3a276f 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -153,6 +153,19 @@
> >   				clock-names = "pit";
> >   			};
> >
> > +			ftm0: ftm@40038000 {
> > +				compatible = "fsl,vf610-ftm-timer";
> > +				reg = <0x40038000 0x2000>;
> > +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> > +				clock-names = "ftm0", "ftm1",
> > +					"ftm0_counter_en", "ftm1_counter_en";
> > +				clocks = <&clks VF610_CLK_FTM0>,
> > +					<&clks VF610_CLK_FTM1>,
> > +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> > +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> > +				status = "disabled";
> > +			};
> > +
> >   			wdog@4003e000 {
> >   				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
> >   				reg = <0x4003e000 0x1000>;
> >
> 
> 
> --
>   <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
