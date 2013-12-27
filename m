Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3L0JIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:08:18 -0500
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:33910
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754060Ab3L0JIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:08:16 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv4 2/4] ARM: dts: Add Freescale SAI ALSA SoC Digital
 Audio Interface node for VF610.
Thread-Topic: [PATCHv4 2/4] ARM: dts: Add Freescale SAI ALSA SoC Digital
 Audio Interface node for VF610.
Thread-Index: AQHO/Sa+uGbX95GUw0WP/tIzSnlqC5pnx+mAgAACYJA=
Date: Fri, 27 Dec 2013 09:08:13 +0000
Message-ID: <4d5402daa3384da795fdb895531e32a6@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1387501387-2151-1-git-send-email-Li.Xiubo@freescale.com>
 <1387501387-2151-2-git-send-email-Li.Xiubo@freescale.com>
 <20131227085322.GA3367@S2101-09.ap.freescale.net>
In-Reply-To: <20131227085322.GA3367@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(164054003)(51704005)(77982001)(83072002)(65816001)(80022001)(19580395003)(66066001)(81686001)(59766001)(87266001)(79102001)(81342001)(56776001)(85852003)(85306002)(54316002)(81542001)(80976001)(81816001)(63696002)(74366001)(87936001)(74316001)(46102001)(49866001)(47736001)(50986001)(47976001)(4396001)(74706001)(54356001)(76482001)(74876001)(53806001)(74662001)(83322001)(47446002)(74502001)(33646001)(31966008)(76796001)(76786001)(90146001)(56816005)(51856001)(69226001)(76576001)(2656002)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB475;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index e84d84c..2d6ddd0 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -166,6 +166,9 @@
> >  				interrupts = <0 86 0x04>;
> >  				clocks = <&clks VF610_CLK_SAI2>;
> >  				clock-names = "sai";
> > +				dma-names = "tx", "rx";
> > +				dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
> > +					<&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
> 
> Where are these VF610_EDMA_MUXID0_* macros defined?  I cannot find them
> in my tree.
>

Sorry, this is depended on the eDMA driver, which is still doing the upstream
work by another colleague.

I will let you know if the eDMA driver has been merged in.


Thanks,

Best Regards,
Xiubo
 

