Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaENKwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:52:16 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:28741
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752925AbaENKwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:52:15 -0400
X-Greylist: delayed 863 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 06:52:14 EDT
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Stanislav Meduna <stano@meduna.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: RE: Freescale FEC i.MX28 VLAN support?
Thread-Topic: Freescale FEC i.MX28 VLAN support?
Thread-Index: AQHPb117rlhoJapyjkC2Emq6lusmNps/4VrQ
Date: Wed, 14 May 2014 10:37:47 +0000
Message-ID: <af16d562c5674929a5d12f0625a5685a@BLUPR03MB373.namprd03.prod.outlook.com>
References: <5373418F.6090602@meduna.org>
In-Reply-To: <5373418F.6090602@meduna.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(377454003)(164054003)(20776003)(81542001)(79102001)(101416001)(85852003)(83072002)(86362001)(76482001)(2656002)(81342001)(64706001)(92566001)(4396001)(2201001)(77096999)(74662001)(33646001)(19580395003)(74502001)(76576001)(74316001)(31966008)(99396002)(66066001)(21056001)(54356999)(87936001)(83322001)(77982001)(19580405001)(50986999)(99286001)(46102001)(76176999)(80022001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB373;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stano,

From: Stanislav Meduna <stano@meduna.org> Data: Wednesday, May 14, 2014 6:13 PM
>To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Linux ARM Kernel
>Subject: Freescale FEC i.MX28 VLAN support?
>
>Hi,
>
>is there any particular reason why the FEC_QUIRK_HAS_VLAN is only set for imx6q-
>fec ?
>
>According to the reference manual the VLAN support is also present in i.MX28 and
>the DMA descriptors look the same in this regard, but this is from eyeballing only,
>I did not try to play with it yet.
>
>The reason I am asking is that I am using a switch that can tag the frames
>according to the port a packet is received from/sent to and I would like to use
>that feature.
>
>Please Cc: me when replying.
>
>Thanks
>--
>                                Stano

Imx28 also support the feature, you can enable it.
HW only support detect VLAN packet. The function with the config just using software to remove VLAN tag while receiving one packet.

Thanks,
Andy
