Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaD1O1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:27:04 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:17166
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752171AbaD1O1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:27:01 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Topic: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Index: AQHPRMe0k0rd8jXWS0KRu9iApNrcapsnPO0AgAARnE0=
Date: Mon, 28 Apr 2014 14:26:57 +0000
Message-ID: <e5e350afaa7b42cfbd93f52130560064@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>,<20140428131034.GA15946@ulmo>
In-Reply-To: <20140428131034.GA15946@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.48.101.7]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(164054003)(83072002)(87936001)(83322001)(99286001)(76176999)(77096999)(2656002)(79102001)(80022001)(20776003)(101416001)(99396002)(76482001)(74316001)(33646001)(31966008)(77982001)(92566001)(50986999)(66066001)(54356999)(76576001)(80976001)(85852003)(81542001)(4396001)(74662001)(86362001)(46102001)(81342001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:7E27C56C.6CF35C0B.99E1BBB8.8E6FAC2.201C0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> > Xiubo Li (3):
> >   pwm: ftm-pwm: Clean up the code.
> >   pwm: ftm-pwm: Convert to direct regmap API usage.
> >   pwm: ftm-pwm: Add big-endian support
> >
> >  drivers/pwm/pwm-fsl-ftm.c | 96 ++++++++++++++++++++++++++---------------------
> >  1 file changed, 53 insertions(+), 43 deletions(-)
>
> This leaves me with only very vague idea of why this is necessary and
> why it should be merged.
>
> Please describe in more detail (in both the cover-letter and each
> individual patch) why you want me to apply these patches.
>

Thanks very much for your reply.

Should I resend this patch series? If so, I will add some thing like the following:

The FTM PWM driver will be used in our Vybrid, LS1 and LS2+ SoCs, and on Vybrid
and LS2 SoCs, the FTM devices are in LE mode, while on LS1 SoCs it in BE mode.

So this patch series add endianness support based on the regmap core, which has
already support the rich endiannesses for the same device.

Thanks,

BRs
Xiubo
