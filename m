Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaIIBzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:55:37 -0400
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:52736
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755372AbaIIBzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:55:36 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 1/4] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Topic: [PATCHv2 1/4] Clocksource: Flextimer: Use internal clocksource
 read API.
Thread-Index: AQHPyM3Ey4Hred0UCkWbQ/cLLeLlTpvyrdMAgAVil/A=
Date: Tue, 9 Sep 2014 01:55:33 +0000
Message-ID: <92e51da8df704197959434bc9a4e28c7@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
 <1409893340-30027-2-git-send-email-Li.Xiubo@freescale.com>
 <alpine.DEB.2.10.1409051730270.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409051730270.5472@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(189002)(199003)(164054003)(51704005)(377454003)(24454002)(13464003)(79102001)(46102001)(85852003)(90102001)(80022001)(66066001)(83072002)(74316001)(108616004)(77096002)(83322001)(50986999)(64706001)(21056001)(76176999)(33646002)(99396002)(19580405001)(54356999)(97736003)(2656002)(86362001)(106116001)(77982001)(110136001)(20776003)(4396001)(87936001)(76576001)(76482001)(101416001)(99286002)(107046002)(74662001)(74502001)(19580395003)(85306004)(92566001)(81542001)(31966008)(95666004)(106356001)(81342001)(105586002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Okay.

I will try to fix this.

Thanks,

BRs
Xiubo




> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, September 05, 2014 11:40 PM
> To: Xiubo Li-B47053
> Cc: daniel.lezcano@linaro.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv2 1/4] Clocksource: Flextimer: Use internal clocksource
> read API.
> 
> On Fri, 5 Sep 2014, Xiubo Li wrote:
> 
> > Since the Flextimer device will be implemented in BE mode on
> > LS1 SoC, and in LE mode on Vybrid, LS2 SoCs, so here we need
> > the endianness judgment before doing the mmio.
> 
> WTF? I explained you in great length HOW you should solve that, but
> you just ignore it. Instead of trying to understand what I say you
> just resend the same nonsense again.
> 
> Keep that attitude up, if you want to make sure, that your patches are
> ignored in the future.
> 
> Thanks,
> 
> 	tglx
