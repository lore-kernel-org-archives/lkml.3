Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaAFFZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:25:39 -0500
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:41860
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaAFFZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:25:37 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "bpringlemeir@nbsps.com" <bpringlemeir@nbsps.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHPCEvHgiIG4cfLhk+jSAVclg4YcZpynt6AgAAUaXCAAO2LAIADjWug
Date: Mon, 6 Jan 2014 05:25:32 +0000
Message-ID: <0773adbc0c0f4406ab6df6480d4aef51@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388726661-3391-1-git-send-email-Li.Xiubo@freescale.com>
 <20140103074511.GA10680@core.coreip.homeip.net>
 <f9527d65aa234f40af2830d9fb139bbb@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140103230826.GB13489@core.coreip.homeip.net>
In-Reply-To: <20140103230826.GB13489@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0083A7F08A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(164054003)(189002)(199002)(74316001)(33646001)(74366001)(56776001)(76796001)(76786001)(85306002)(76576001)(59766001)(77982001)(66066001)(65816001)(80022001)(79102001)(63696002)(47736001)(49866001)(47976001)(4396001)(50986001)(54316002)(76482001)(74502001)(47446002)(74706001)(74876001)(31966008)(74662001)(83322001)(69226001)(54356001)(51856001)(46102001)(53806001)(81686001)(83072002)(85852003)(80976001)(56816005)(2656002)(87266001)(90146001)(87936001)(81542001)(81342001)(81816001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB224;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static inline int fsl_pwm_calculate_default_ps(struct fsl_pwm_chip *fpc,
> > > > +					       enum fsl_pwm_clk index)
> > > > +{
> > >
> > > Why do you declare this (and other module-local) function as inline?
> > > It is usually better let compiler decide if given function should be
> > > inlined or not.
> > >
> >
> > Could the compiler know when the given function should be inlined by
> > not declare it?
> 
> Yes.
> 
> > And when will be inlined ?
> 
> When it makes sense to do so from compiler's point of view: i.e. it is
> smallish or with single call site and there are enough registers, etc,
> etc.
>

Well, the inline is not very useful here, I will revise this.


Thanks,

--
Best Regards,
Xiubo
