Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaEHCC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:02:58 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:22958
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752813AbaEHCCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:02:53 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Brian Lilly <brian@crystalfontz.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        Jim Baxter <jim_baxter@mentor.com>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@pengutronix.de>
Subject: RE: i.MX28 based system losing eth0 on boot
Thread-Topic: i.MX28 based system losing eth0 on boot
Thread-Index: AQHPaUqPRPwnYFacnkmlPEIwo6F7SJsz2rmAgAAQ6ACAAANwAIAAJfWAgAAHIICAAAX2gIAATjSAgAEO4ICAAAT2gIAABMYAgABi2CA=
Date: Thu, 8 May 2014 01:47:22 +0000
Message-ID: <acba044454de4ade8388d81584e96b33@BLUPR03MB373.namprd03.prod.outlook.com>
References: <CAOk88BLR=nwNGdT++39vLdOt=TwZmemF-trSQPY8AdMN9tKtKQ@mail.gmail.com>
 <20140506181151.GU28564@pengutronix.de>
 <CAOk88BJ+sCtM_cRLuBktUKWYHcPo6KtQ+GAgTJL0zBgQqcQYog@mail.gmail.com>
 <CAGVrzcZs9-f4bCLNv3-s9iubMk8SF8P9+aJaere7rdLbvfo0bw@mail.gmail.com>
 <CAOk88B+5CQZ639S_DwprrdBwZCs9m1cN_hr5hDRVkP18DqHd0w@mail.gmail.com>
 <CAGVrzcbdm-owTaz6ENZMCCGDxQsSaHoEVP=5ex9kZj-FprqUxQ@mail.gmail.com>
 <CAOk88BKmoSytTCXrXgsAGQXhUYvXqCPeX7TmYBRST+K8e0bv3w@mail.gmail.com>
 <CAGVrzcaL6817-WQ73srFHC022QY9LOJwQyx=uxqjHBt+Cf7ZRg@mail.gmail.com>
 <CAOk88BLCq4s8Lb4SLpTS9Mmz2Qe2g5+9ENw7h6huQdXBv_Nq0A@mail.gmail.com>
 <CAGVrzcY0ooeCvu5oQVieW8G4kpzGS6M=d3T8WjxsnZvC8tNXmA@mail.gmail.com>
 <CAOk88BJz3HgQHmYPz9y1i4xn89wjpnGDutLw8wKDguJ1+H3Mjw@mail.gmail.com>
In-Reply-To: <CAOk88BJz3HgQHmYPz9y1i4xn89wjpnGDutLw8wKDguJ1+H3Mjw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(51704005)(164054003)(189002)(199002)(76482001)(80022001)(66066001)(4396001)(19580405001)(64706001)(20776003)(21056001)(81542001)(83322001)(19580395003)(74662001)(50986999)(76176999)(54356999)(99396002)(74502001)(87936001)(99286001)(81342001)(77096999)(2656002)(86362001)(46102001)(83072002)(85852003)(77982001)(76576001)(33646001)(74316001)(101416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB248;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s48230kJ024167

From: Brian Lilly <brian@crystalfontz.com>
Data: Thursday, May 08, 2014 3:52 AM

>To: Florian Fainelli
>Cc: Uwe Kleine-KÃ¶nig; David S. Miller; Estevam Fabio-R49496; Jim Baxter; Li Frank-
>B20596; Duan Fugang-B38611; netdev; linux-kernel@vger.kernel.org; kernel
>Subject: Re: i.MX28 based system losing eth0 on boot
>
>Florian:
>
>Thank you for your help.
>
>After doubling the timeout length it worked.
>
>I managed to get my hands on a imx28evk board and compared our component load
>versus theirs, to find they have a 1.5k pull-up on ENET_MDIO to +3.3v which wasn't
>present on our board.  Adding a 1.5k pull-up resistor on ENET_MDIO solves the
>problem, and boots as expected without patching anything.
>
>Sorry for the trouble on this.
>
>Apparently our EE had some question as to whether or not the pull-up was necessary,
>and put it in the schematic, and the footprint on the board, but marked it as a
>DNP, which of course left it off the board and out of the BOM.
[...]

Yes, 1.5K pull-up on MDIO is necessary, otherwise write/read phy register data is not right due to the drive strength is not enough.

Thanks,
Andy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
