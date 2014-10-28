Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbaJ1GBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:01:38 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:60740
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933563AbaJ1GBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:01:34 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/3] pwm: ftm: add Power Management support
Thread-Topic: [PATCH v2 0/3] pwm: ftm: add Power Management support
Thread-Index: AQHP6Df/Ewkv3RMNekymn6py5vm4o5xFF6Wg
Date: Tue, 28 Oct 2014 06:01:31 +0000
Message-ID: <549e977528334f08a2652eda14a6ee6e@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1413350495-40980-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
x-forefront-prvs: 0378F1E47A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(6009001)(13464003)(51704005)(199003)(189002)(164054003)(377454003)(99286002)(106356001)(106116001)(66066001)(64706001)(4396001)(105586002)(80022003)(46102003)(40100003)(122556002)(95666004)(20776003)(74316001)(85306004)(99396003)(107046002)(87936001)(76482002)(77096002)(85852003)(19580405001)(19580395003)(92566001)(86362001)(101416001)(120916001)(50986999)(76176999)(76576001)(108616004)(54356999)(21056001)(31966008)(2501002)(97736003)(33646002)(2656002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry, 

Ping...


Thanks,

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

