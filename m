Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaD1PQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:16:20 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:2412
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756501AbaD1PQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:16:15 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] pwm: ftm-pwm: Clean up the code.
Thread-Topic: [PATCH 1/3] pwm: ftm-pwm: Clean up the code.
Thread-Index: AQHPRMevwrNlKVU6O0Sh14GZPdLzgJsnWroAgAAE9EQ=
Date: Mon, 28 Apr 2014 15:16:07 +0000
Message-ID: <6604daa9d83542d9af0fac727b761102@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-2-git-send-email-Li.Xiubo@freescale.com>,<20140428145703.GB28443@ulmo>
In-Reply-To: <20140428145703.GB28443@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.48.101.7]
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(51704005)(189002)(199002)(33646001)(87936001)(81342001)(77096999)(83072002)(81542001)(76576001)(79102001)(76482001)(4396001)(50986999)(46102001)(2656002)(54356999)(99396002)(76176999)(19580405001)(80022001)(66066001)(74316001)(92566001)(19580395003)(77982001)(99286001)(74662001)(85852003)(80976001)(86362001)(20776003)(31966008)(101416001)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:9C05E727.E120101A.45E6B8CF.C4AD88A5.200B7;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  drivers/pwm/pwm-fsl-ftm.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> The patch description here could explain that this is in preparation for
> the conversion to regmap (which I assume it is).
>

Please see the next version, I`ll explain it.

Thanks,

BRs
Xiubo
