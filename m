Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaLADZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:25:09 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:35200
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbaLADZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:25:07 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: RE: [PATCH v2 0/3] pwm: ftm: add Power Management support
Thread-Topic: [PATCH v2 0/3] pwm: ftm: add Power Management support
Thread-Index: AQHP6Df/Ewkv3RMNekymn6py5vm4o5x6XAxw
Date: Mon, 1 Dec 2014 03:25:02 +0000
Message-ID: <BY2PR0301MB06135ED75E8DCEC04E442E0B9B7D0@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(13464003)(377454003)(199003)(106116001)(106356001)(107046002)(110136001)(2501002)(105586002)(74316001)(21056001)(77096004)(97736003)(86362001)(2656002)(2351001)(40100003)(122556002)(99396003)(54606007)(31966008)(62966003)(77156002)(4396001)(120916001)(101416001)(19580405001)(54356999)(33656002)(92566001)(99286002)(20776003)(19580395003)(92726001)(64706001)(76576001)(95666004)(66066001)(76176999)(87936001)(50986999)(46102003)(54206007);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping :) .

Thanks very much.

BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, October 15, 2014 1:22 PM
> To: thierry.reding@gmail.com; linux-pwm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCH v2 0/3] pwm: ftm: add Power Management support
> 
> Changes in v2:
> - Fix one bug.
> - Add regmap cache support.
> - Remove run time PM for now.
> 
> Xiubo Li (3):
>   pwm: ftm: fix one bug of wrong counting the use counter.
>   pwm: ftm: add regmap rbtree type cache support.
>   pwm: ftm: add Power Management support for FTM pwm.
> 
>  drivers/pwm/pwm-fsl-ftm.c | 64 ++++++++++++++++++++++++++++++++++++++++++++--
> -
>  1 file changed, 60 insertions(+), 4 deletions(-)
> 
> --
> 2.1.0.27.g96db324

