Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaIZDOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:14:32 -0400
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:35053
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752437AbaIZDOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:14:31 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Shengchao Guo <Shawn.Guo@freescale.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Topic: [PATCH v3] ARM: ls1021a: add gating clocks to IP blocks.
Thread-Index: AQHP1yw1xpt6riX400mCXn9hhSG2j5wRjisAgAAB8dCAARvuAIAAAOlQ
Date: Fri, 26 Sep 2014 03:14:26 +0000
Message-ID: <eb17fb36d1a04812836ad46bace8c4bf@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411476275-9164-1-git-send-email-Li.Xiubo@freescale.com>
 <20140925085403.GG6405@dragon>
 <e44a1930e8de43ec8beb6e60fa9c1e9e@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140926015713.GG21077@dragon>
In-Reply-To: <20140926015713.GG21077@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;UriScan:;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(164054003)(51704005)(189002)(199003)(20776003)(64706001)(83072002)(85852003)(74316001)(33646002)(66066001)(99396003)(83322001)(110136001)(107046002)(76176999)(50986999)(54356999)(101416001)(77096002)(85306004)(31966008)(93886004)(21056001)(46102003)(77982003)(76576001)(4396001)(106356001)(120916001)(105586002)(95666004)(92566001)(86362001)(106116001)(87936001)(97736003)(10300001)(99286002)(79102003)(81342003)(90102001)(76482002)(108616004)(74662003)(2656002)(74502003)(80022003)(81542003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB403;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As the parent of the clocks registered by this function is "dummy" from
> > > what I see, what is the point of setting flag CLK_SET_RATE_PARENT then?
> > >
> > > > +			CLK_IGNORE_UNUSED, reg,	shift,
> > >
> > > Why flag CLK_IGNORE_UNUSED?
> > >
> >
> > As the SoC reference manual all the IP blocks will be enabled when powered
> up.
> > But the Linux OS will disable all the IP blocks' clocks as default without
> this.
> >
> > For now, this gate driver will only used for PM support of some IP blocks.
> For the
> > Others needed to be enabled as default.
> 
> Ok, got it. I'm fine with the flag then, and we can remove it after all
> those client devices manage their clocks well.
> 

Okay.

Thanks,

BRs
Xiubo


> Shawn


