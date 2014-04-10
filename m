Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbaDJGFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:05:54 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:46423
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933287AbaDJGFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:05:52 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Topic: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Thread-Index: AQHPRMe0k0rd8jXWS0KRu9iApNrcapsKfAGg
Date: Thu, 10 Apr 2014 06:05:31 +0000
Message-ID: <1e190701f1b54403b94057472c7cbc56@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(377454003)(51704005)(189002)(199002)(13464003)(92566001)(79102001)(85852003)(76576001)(74316001)(81342001)(2201001)(77982001)(20776003)(81542001)(99286001)(87936001)(4396001)(19580405001)(46102001)(86362001)(33646001)(74502001)(83322001)(76482001)(99396002)(66066001)(2656002)(80976001)(83072002)(19580395003)(80022001)(74662001)(31966008)(54356999)(50986999)(76176999)(77096999)(24736002)(217873001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB506;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:685F47B2.1C839F2E.39653BAC.D4E6F9CA.20124;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Therry,

Ping :)



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Friday, March 21, 2014 12:53 PM
> To: thierry.reding@gmail.com; linux-pwm@vger.kernel.org
> Cc: broonie@kernel.org; swarren@nvidia.com; linux-kernel@vger.kernel.org;
> Xiubo Li-B47053
> Subject: [PATCH 0/3] FTM PWM adds regmap and endianness support.
> 
> 
> Xiubo Li (3):
>   pwm: ftm-pwm: Clean up the code.
>   pwm: ftm-pwm: Convert to direct regmap API usage.
>   pwm: ftm-pwm: Add big-endian support
> 
>  drivers/pwm/pwm-fsl-ftm.c | 96 ++++++++++++++++++++++++++--------------------
> -
>  1 file changed, 53 insertions(+), 43 deletions(-)
> 
> --
> 1.8.4
> 

