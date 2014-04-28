Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaD1PVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:21:54 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:22948
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932376AbaD1PVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:21:49 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Topic: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Index: AQHPRMe0k0rd8jXWS0KRu9iApNrcapsnPO0AgAARnE2AAAvqAIAABswJ
Date: Mon, 28 Apr 2014 15:21:47 +0000
Message-ID: <106747c19727435782fe197a96946490@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <20140428131034.GA15946@ulmo>
 <e5e350afaa7b42cfbd93f52130560064@BY2PR03MB505.namprd03.prod.outlook.com>,<20140428145615.GA28443@ulmo>
In-Reply-To: <20140428145615.GA28443@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.48.101.7]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(85852003)(81542001)(74662001)(4396001)(54356999)(80976001)(76576001)(81342001)(86362001)(46102001)(79102001)(80022001)(99286001)(76176999)(83322001)(83072002)(87936001)(2656002)(77096999)(77982001)(31966008)(66066001)(92566001)(50986999)(99396002)(101416001)(20776003)(33646001)(74316001)(76482001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B01AC46C.9CC0540A.79E09DAC.8E43E31.2013E;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Should I resend this patch series? If so, I will add some thing like the following:
> >
> > The FTM PWM driver will be used in our Vybrid, LS1 and LS2+ SoCs, and on Vybrid
> > and LS2 SoCs, the FTM devices are in LE mode, while on LS1 SoCs it in BE mode.
> >
> > So this patch series add endianness support based on the regmap core, which has
> > already support the rich endiannesses for the same device.
>
> Yes, please resend with that description added where appropriate. I'd
> like to see something like that in the cover letter and, more
> importantly, in the individual patches.
>

Okay, Please see the next version.

Thanks,

BRs
Xiubo