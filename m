Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaD1POg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:14:36 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:41273
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756345AbaD1POf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:14:35 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] pwm: ftm-pwm: Convert to direct regmap API usage.
Thread-Topic: [PATCH 2/3] pwm: ftm-pwm: Convert to direct regmap API usage.
Thread-Index: AQHPRMexf1UHG9X2okmKzOPqm4shaJsnW1uAgAADhio=
Date: Mon, 28 Apr 2014 15:14:30 +0000
Message-ID: <74580957bdd04894aa303b86f4fb536a@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-3-git-send-email-Li.Xiubo@freescale.com>,<20140428145930.GC28443@ulmo>
In-Reply-To: <20140428145930.GC28443@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.48.101.7]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(164054003)(92566001)(81542001)(20776003)(81342001)(2656002)(80022001)(74662001)(85852003)(76482001)(79102001)(83072002)(76576001)(74316001)(31966008)(86362001)(4396001)(83322001)(80976001)(66066001)(54356999)(76176999)(77982001)(87936001)(46102001)(50986999)(99286001)(99396002)(33646001)(77096999)(101416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:FC15FF65.2D30802A.71D24B8C.4CE4CCED.2016C;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  drivers/pwm/pwm-fsl-ftm.c | 83 +++++++++++++++++++++++++----------------------
> >  1 file changed, 44 insertions(+), 39 deletions(-)
> 
> This could explain the advantages of converting to regmap. Looking at
> this diffstat above, it's not immediately obvious that there's an
> advantage because you end up adding 5 lines.
> 
> Again I'm guessing this is in preparation to add endianess support, and
> it will be really easy to add that using regmap, so the gains will only
> become obvious later on.
> 
> That's the kind of thing I'd like to see in the patch description. It
> tells me why this patch makes sense.
> 

Yes, That`s why converting to use the regmap.

I`ll update this as you have mentioned.

Thanks,
BRs
Xiubo
