Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaD1PLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:11:15 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:14698
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756477AbaD1PLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:11:14 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] pwm: ftm-pwm: Add big-endian support
Thread-Topic: [PATCH 3/3] pwm: ftm-pwm: Add big-endian support
Thread-Index: AQHPRMezaWzckG4I3EeuCqQJu14aPJsnXBYAgAABWZU=
Date: Mon, 28 Apr 2014 15:11:11 +0000
Message-ID: <3f5658518174446e8edfc0038235e4fc@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-4-git-send-email-Li.Xiubo@freescale.com>,<20140428150207.GD28443@ulmo>
In-Reply-To: <20140428150207.GD28443@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.48.101.7]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(77096999)(83322001)(80022001)(19580395003)(99396002)(54356999)(85852003)(4396001)(2656002)(46102001)(87936001)(76576001)(76482001)(19580405001)(33646001)(79102001)(92566001)(81342001)(77982001)(81542001)(50986999)(83072002)(31966008)(99286001)(20776003)(74316001)(66066001)(76176999)(74662001)(86362001)(101416001)(80976001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:54C6E824.733D1D81.ADD79FBF.88A45AF1.2015D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Now for the following scenarios:
> >
> >      SoC     |  CPU   | FTM-PWM | 'big-endian' property is needed?
> > -------------|--------|---------|---------------------------------
> >     Vybird   |  LE    |   LE    |     No
> >     LS1     |  LE    |   BE    |     Yes
> >     LS2     |  LE    |   LE    |     No
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  drivers/pwm/pwm-fsl-ftm.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> 
> And this should probably describe in text what happens. The table may
> look good, but you don't give a real description of what the change
> does.
> 

I will follow your advice.


> Oh, and doesn't this change need to update the device tree binding since
> you now have an additional property?
>

Yes, you are right. I just forgot it.

I will add update it.

Thanks very much.

BRs
XIubo

