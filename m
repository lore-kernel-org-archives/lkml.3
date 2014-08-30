Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbaH3BAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:00:20 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:25489
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbaH3BAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:00:19 -0400
Message-ID: <1409360401.24184.41.camel@snotra.buserror.net>
Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Lu Jingchang-B35083 <jingchang.lu@freescale.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 29 Aug 2014 20:00:01 -0500
In-Reply-To: <c5564f8aa16b4156837a5fc4134036fb@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1408700096-25415-1-git-send-email-jingchang.lu@freescale.com>
	 <1409093463.6510.92.camel@snotra.buserror.net>
	 <164af7b3be3747a0be3fe3a6cf83d3b1@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1409182412.6510.129.camel@snotra.buserror.net>
	 <f7b4263f189346a391d66c85756b4907@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1409243145.6510.160.camel@snotra.buserror.net>
	 <c5564f8aa16b4156837a5fc4134036fb@BL2PR03MB467.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:6853:5536:db43:a2c7]
X-ClientProxiedBy: DM2PR04CA038.namprd04.prod.outlook.com (10.141.154.156) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031996B7EF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(979002)(6009001)(377424004)(13464003)(189002)(199003)(377454003)(24454002)(51704005)(104166001)(76176999)(107046002)(31966008)(90102001)(50466002)(77096002)(50986999)(33646002)(103116003)(99396002)(42186005)(106356001)(102836001)(105586002)(110136001)(86362001)(95666004)(85306004)(19580405001)(19580395003)(76482001)(83322001)(77156001)(62966002)(80022001)(79102001)(88136002)(101416001)(87976001)(21056001)(23676002)(46102001)(4396001)(74662001)(74502001)(83072002)(93886004)(89996001)(92726001)(20776003)(93916002)(50226001)(85852003)(77982001)(87286001)(47776003)(92566001)(81542001)(81342001)(64706001)(99106002)(3826002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0727;H:[IPv6:2601:2:5800:3f7:6853:5536:db43:a2c7];FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 02:17 -0500, Lu Jingchang-B35083 wrote:
> >-----Original Message-----
> >From: Wood Scott-B07421
> >Sent: Friday, August 29, 2014 12:26 AM
> >To: Lu Jingchang-B35083
> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based platforms
> >CLK_OF_DECLARE support
> >
> >On Thu, 2014-08-28 at 05:05 -0500, Lu Jingchang-B35083 wrote:
> >> >-----Original Message-----
> >> >From: Wood Scott-B07421
> >> >Sent: Thursday, August 28, 2014 7:34 AM
> >> >To: Lu Jingchang-B35083
> >> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based
> >> >platforms CLK_OF_DECLARE support
> >> >
> >> >On Tue, 2014-08-26 at 21:19 -0500, Lu Jingchang-B35083 wrote:
> >> >> >-----Original Message-----
> >> >> >From: Wood Scott-B07421
> >> >> >Sent: Wednesday, August 27, 2014 6:51 AM
> >> >> >To: Lu Jingchang-B35083
> >> >> >Cc: mturquette@linaro.org; linuxppc-dev@lists.ozlabs.org; linux-
> >> >> >kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >> >> >Subject: Re: [RESEND] clk: ppc-corenet: Add Freescale ARM-based
> >> >> >platforms CLK_OF_DECLARE support
> >> >> >
> >> >> >On Fri, 2014-08-22 at 17:34 +0800, Jingchang Lu wrote:
> >> >> >> +CLK_OF_DECLARE(ppc_core_pll_v1, "fsl,qoriq-core-pll-1.0",
> >> >> >core_pll_init);
> >> >> >> +CLK_OF_DECLARE(ppc_core_pll_v2, "fsl,qoriq-core-pll-2.0",
> >> >> >core_pll_init);
> >> >> >> +CLK_OF_DECLARE(ppc_core_mux_v1, "fsl,qoriq-core-mux-1.0",
> >> >> >core_mux_init);
> >> >> >> +CLK_OF_DECLARE(ppc_core_mux_v2, "fsl,qoriq-core-mux-2.0",
> >> >> >core_mux_init);
> >> >> >
> >> >> >What does this do that the existing platform driver and match
> >> >> >table don't?  Why is it needed for ARM when PPC didn't need it?
> >> >> >
> >> >> >-Scott
> >> >> >
> >> >> Common clk init on ARM platform is initialized earlier via
> >> >> of_clk_init() instead of driver probe method, the of_clk_init will
> >> >> walk a __clk_of_table to init each clk provider in the table, the
> >> >> CLK_OF_DECLARE() macro puts a supported clk in the __clk_of_table
> >> >> for it
> >> >initializing on starup, and the clk system has added some common clk
> >> >such as "fixed-clk"
> >> >> to this table already.
> >> >> So here I add our specific clk init declaration to consist this
> >> >> framework, and the driver probe function will not be needed on ARM.
> >> >
> >> >OK... Is there any reason why the new method won't work on PPC?
> >> >
> >> PPC has little dependence on the clock tree but frequency, it will
> >> work well if adopted I think.
> >
> >I'm just saying it seems redundant to have both.  Even on ARM, won't this
> >result in the clock getting registered twice (albeit with one of those
> >times being too late)?
> >
> >Regardless of what dependence PPC has on the clock tree, what stops this
> >method of enumeration from working on PPC?  Is there anything required
> >other than inserting a call to of_clk_init(NULL) in the arch init code?
> >
> >-Scott
> >
> The of_clk_init is an alternative way to the legacy driver. 
> Latest ARM standard support a default call to of_clk_init(NULL) in its time_init().
> So this is the general way for ARM-based platform.

Why are such things dependent on CPU architecture?

> The clk register layer can detect the twice registration of a same clk and
> avoid the duplicate registration. The dtb should select the compatible for either,
> but not both.

Either but not both of what?

> On LS1021A the driver probe method will not be triggered.
> And for support of of_clk_init on PPC, I think just add a call to it as ARM do
> in time_init()[arch/arm/kernel/time.c] would be ok.

I'd rather see this happen than have the driver have to register itself
differently on different architectures.

-Scott


