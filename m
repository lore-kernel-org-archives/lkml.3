Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaH2HRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:17:41 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:19834
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752943AbaH2HRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:17:39 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
Thread-Topic: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
Thread-Index: AQHPvfNVs2TWqmkiQk6JTABVnWcu25vjhIaAgAAsoICAAXGTAIAArlqAgABsdoCAAO+zEA==
Date: Fri, 29 Aug 2014 07:17:35 +0000
Message-ID: <c5564f8aa16b4156837a5fc4134036fb@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
	 <1409093463.6510.92.camel@snotra.buserror.net>
	 <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1409182412.6510.129.camel@snotra.buserror.net>
	 <f7b4263f189346a391d66c85756b4907@BL2PR03MB467.namprd03.prod.outlook.com>
 <1409243145.6510.160.camel@snotra.buserror.net>
In-Reply-To: <1409243145.6510.160.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(377454003)(199003)(51704005)(24454002)(189002)(377424004)(76482001)(46102001)(81342001)(76176999)(101416001)(66066001)(110136001)(2656002)(83322001)(77982001)(64706001)(90102001)(76576001)(99396002)(79102001)(20776003)(50986999)(92566001)(54356999)(74316001)(80022001)(74502001)(85306004)(87936001)(33646002)(107046002)(93886004)(106116001)(19580405001)(31966008)(81542001)(85852003)(19580395003)(95666004)(74662001)(86362001)(105586002)(83072002)(21056001)(4396001)(108616004)(106356001)(99286002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0736;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:3;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7T7HjEa023382

>-----Original Message-----
>From: Wood Scott-B07421
>Sent: Friday, August 29, 2014 12:26 AM
>To: Lu Jingchang-B35083
>Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
>CLK_OF_DECLARE support
>
>On Thu, 2014-08-28 at 05:05 -0500, Lu Jingchang-B35083 wrote:
>> >-----Original Message-----
>> >From: Wood Scott-B07421
>> >Sent: Thursday, August 28, 2014 7:34 AM
>> >To: Lu Jingchang-B35083
>> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
>> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based
>> >platforms CLK_OF_DECLARE support
>> >
>> >On Tue, 2014-08-26 at 21:19 -0500, Lu Jingchang-B35083 wrote:
>> >> >-----Original Message-----
>> >> >From: Wood Scott-B07421
>> >> >Sent: Wednesday, August 27, 2014 6:51 AM
>> >> >To: Lu Jingchang-B35083
>> >> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
>> >> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>> >> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based
>> >> >platforms CLK_OF_DECLARE support
>> >> >
>> >> >On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
>> >> >> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0",
>> >> >core_pll_init);
>> >> >> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0",
>> >> >core_pll_init);
>> >> >> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0",
>> >> >core_mux_init);
>> >> >> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0",
>> >> >core_mux_init);
>> >> >
>> >> >What does this do that the existing platform driver and match
>> >> >table don't?  Why is it needed for ARM when PPC didn't need it?
>> >> >
>> >> >-Scott
>> >> >
>> >> Common clk init on ARM platform is initialized earlier via
>> >> of_clk_init() instead of driver probe method, the of_clk_init will
>> >> walk a __clk_of_table to init each clk provider in the table, the
>> >> CLK_OF_DECLARE() macro puts a supported clk in the __clk_of_table
>> >> for it
>> >initializing on starup, and the clk system has added some common clk
>> >such as "fixed-clk"
>> >> to this table already.
>> >> So here I add our specific clk init declaration to consist this
>> >> framework, and the driver probe function will not be needed on ARM.
>> >
>> >OK... Is there any reason why the new method won't work on PPC?
>> >
>> PPC has little dependence on the clock tree but frequency, it will
>> work well if adopted I think.
>
>I'm just saying it seems redundant to have both.  Even on ARM, won't this
>result in the clock getting registered twice (albeit with one of those
>times being too late)?
>
>Regardless of what dependence PPC has on the clock tree, what stops this
>method of enumeration from working on PPC?  Is there anything required
>other than inserting a call to of_clk_init(NULL) in the arch init code?
>
>-Scott
>
The of_clk_init is an alternative way to the legacy driver. 
Latest ARM standard support a default call to of_clk_init(NULL) in its time_init().
So this is the general way for ARM-based platform.
The clk register layer can detect the twice registration of a same clk and
avoid the duplicate registration. The dtb should select the compatible for either,
but not both. On LS1021A the driver probe method will not be triggered.
And for support of of_clk_init on PPC, I think just add a call to it as ARM do
in time_init()[arch/arm/kernel/time.c] would be ok.



Best Regards,
Jingchang





ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
