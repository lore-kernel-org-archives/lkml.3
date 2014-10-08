Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaJHEAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:00:46 -0400
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:7905
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbaJHEAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:00:45 -0400
X-Greylist: delayed 1943 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2014 00:00:45 EDT
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Topic: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Index: AQHP1wZitlVyPqyKzkCzCdgy6a+s/ZwRnYeAgACtOwCAAC5pAIAAAJ8AgAGbdgCAAbx24IADApyAgAzI0lA=
Date: Wed, 8 Oct 2014 03:28:20 +0000
Message-ID: <920830473fda4de3abcbf5ae11dd2360@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
	 <d4a375f40b544cf1ae78ac82dc20569c@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1411675680.13320.201.camel@snotra.buserror.net>
	 <20140925225406.19023.25065@quantum>
	 <1411685780.13320.209.camel@snotra.buserror.net>
	 <20140926232900.19023.35854@quantum>
	 <d637914864824bda8d0dd62639e9097b@DM2PR03MB574.namprd03.prod.outlook.com>
 <1412035075.13320.302.camel@snotra.buserror.net>
In-Reply-To: <1412035075.13320.302.camel@snotra.buserror.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB479;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(51704005)(164054003)(76104003)(24454002)(13464003)(377424004)(199003)(106116001)(97736003)(106356001)(95666004)(107046002)(87936001)(2656002)(50986999)(110136001)(120916001)(85852003)(21056001)(122556002)(40100002)(99396003)(33646002)(76482002)(54356999)(101416001)(86362001)(31966008)(76176999)(46102003)(80022003)(105586002)(74316001)(66066001)(92566001)(4396001)(108616004)(85306004)(64706001)(19580395003)(20776003)(19580405001)(93886004)(21314002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB479;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9840pQd022141

> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, September 30, 2014 7:58 AM
> To: Tang Yuantian-B29983
> Cc: Mike Turquette; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Lu Jingchang-B35083
> Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
> CLK_OF_DECLARE support
> 
> On Sat, 2014-09-27 at 21:18 -0500, Tang Yuantian-B29983 wrote:
> > > -----Original Message-----
> > > From: Linuxppc-dev
> > > [mailto:linuxppc-dev-bounces+b29983=freescale.com@lists.ozlabs.org]
> > > On Behalf Of Mike Turquette
> > > Sent: Saturday, September 27, 2014 7:29 AM
> > > To: Wood Scott-B07421
> > > Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> > > linux-arm-kernel@lists.infradead.org; Lu Jingchang-B35083
> > > Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
> > > CLK_OF_DECLARE support
> > >
> > > Quoting Scott Wood (2014-09-25 15:56:20)
> > > > On Thu, 2014-09-25 at 15:54 -0700, Mike Turquette wrote:
> > > > > Quoting Scott Wood (2014-09-25 13:08:00)
> > > > > > Well, like I said, I'd rather see the CLK_OF_DECLARE stuff be
> > > > > > made to work on PPC rather than have the driver carry around
> > > > > > two binding methods.
> > > > >
> > > > > I guess that is an existing problem, and not related directly to
> > > > > this patch? This patch is essentially just renames (though the
> > > > > V1.0/V2.0 stuff seems weird).
> > > >
> > > > This patch is adding CLK_OF_DECLARE.
> > >
> > > I'm fine taking this patch but your comments are still unresolved.
> > > What do you think needs to be done to fix the problems that you see?
> > >
> > CLK_OF_DECLARE is totally worked on PPC. I will do it in a separate patch.
> > Regarding V1.0 and V2.0, it is not wired just same for now. But we are not sure
> if it is same for v3.0 in the future.
> >
> > Besides updating drivers/cpufreq/Kconfig.powerpc, there is one more thing I
> am not comfortable with:
> > This patch uses " fixed-clock" as sysclk's compatible string, while on PPC we
> treated it as " fsl,qoriq-sysclk-[1-2].0".
> > That's inconsistent on both ARM and PPC platforms, neither did on bindings.
> 
> fsl,qoriq-sysclk-XXX is the way it is because of compatibility with the fixups in
> existing U-Boots.  It shouldn't be used as a model.
> 
> That said, I don't think you really mean "this patch", as it doesn't contain the
> device tree updates, and "fixed-clock" does not appear.
> 
"fixed-clock" will appear when ls102x platform DTS gets upstreamed eventually.
That would be fine if you don't think "fsl,qoriq-sysclk-xxx" having different meaning on ARM and PowerPC is a issue.

Thanks,
Yuantian
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
