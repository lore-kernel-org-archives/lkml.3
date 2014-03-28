Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaC1EQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 00:16:09 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:45374
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753059AbaC1EQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 00:16:07 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Shawn Guo <Shawn.Guo@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: FW: [PATCHv2 0/2] Add big endian support
Thread-Topic: [PATCHv2 0/2] Add big endian support
Thread-Index: AQHPSKDTg1TdE/v1M0mcN0CEw1LU4Zr15qSg
Date: Fri, 28 Mar 2014 04:15:51 +0000
Message-ID: <6dce4e998c8448cc83826ee7ccb29e9a@BY2PR03MB505.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(377454003)(164054003)(69226001)(47736001)(49866001)(50986001)(47976001)(87936001)(4396001)(95666003)(59766001)(77982001)(76786001)(76576001)(93516002)(74876001)(46102001)(2656002)(19580395003)(80022001)(20776003)(63696002)(79102001)(19580405001)(80976001)(83322001)(65816001)(81816001)(47446002)(74662001)(81686001)(74502001)(31966008)(74316001)(97336001)(76176001)(74706001)(94316002)(95416001)(74366001)(94946001)(98676001)(66066001)(86362001)(33646001)(81542001)(54356001)(87266001)(76482001)(56776001)(85306002)(85852003)(56816005)(90146001)(83072002)(53806001)(81342001)(93136001)(92566001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:B9CF5A9A.2003AD1C.E1E1BBA8.54667BB9.20186;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Forward to Shawn.

Thanks,

> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, March 26, 2014 10:22 AM
> To: wim@iguana.be; w.sang@pengutronix.de; linux-watchdog@vger.kernel.org;
> linux@roeck-us.net
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv2 0/2] Add big endian support
> 
> This patches are preparing for Vybird, LS1 and LS2. And on LS1 the IP will
> in BE mode.
> 
> And this has been test on Vybird.
> 
> Changes in V2:
> - Add the detail information in the commit comment.
> - 'big-endians' --> 'big-endian'.
> 
> 
> Xiubo Li (2):
>   watchdog: imx2_wdt: Sort the header files alphabetically
>   watchdog: imx2_wdt: Add big-endian support
> 
>  drivers/watchdog/imx2_wdt.c | 52 ++++++++++++++++++++++++++++++++------------
> -
>  1 file changed, 37 insertions(+), 15 deletions(-)
> 
> --
> 1.8.4
> 

