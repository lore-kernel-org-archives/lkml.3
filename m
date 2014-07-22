Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaGVG6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:58:51 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:21260
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbaGVG6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:58:50 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Shawn Guo <Shawn.Guo@freescale.com>, Stefan Agner <stefan@agner.ch>
CC: Peter Chen <Peter.Chen@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/6] ARM: imx: clk-vf610: add USBPHY clocks
Thread-Topic: [PATCH 2/6] ARM: imx: clk-vf610: add USBPHY clocks
Thread-Index: AQHPoqn7p6UkNoZSCkinSDryajmVF5urZO0AgABJNsA=
Date: Tue, 22 Jul 2014 06:58:46 +0000
Message-ID: <59acaa7259a54090ab28b037fb412a47@BL2PR03MB467.namprd03.prod.outlook.com>
References: <cover.1405702442.git.stefan@agner.ch>
 <fe660ff42e95a286a954c0560b2b7b2aad81634b.1405702442.git.stefan@agner.ch>
 <20140722023205.GS8537@dragon>
In-Reply-To: <20140722023205.GS8537@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02801ACE41
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(199002)(41574002)(189002)(24454002)(13464003)(99396002)(19580395003)(95666004)(66066001)(76176999)(74662001)(101416001)(46102001)(80022001)(99286002)(106356001)(85306003)(31966008)(85852003)(83072002)(54356999)(21056001)(19580405001)(76576001)(76482001)(106116001)(87936001)(20776003)(107046002)(2656002)(77982001)(50986999)(4396001)(86362001)(74316001)(33646002)(92566001)(81342001)(64706001)(79102001)(81542001)(83322001)(74502001)(105586002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB337;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6M6wvx4003908


>-----Original Message-----
>From: Shawn Guo [mailto:shawn.guo@freescale.com]
>Sent: Tuesday, July 22, 2014 10:32 AM
>To: Stefan Agner; Lu Jingchang-B35083
>Cc: Chen Peter-B29397; s.hauer@pengutronix.de; linux-arm-
>kernel@lists.infradead.org; linux-usb@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH 2/6] ARM: imx: clk-vf610: add USBPHY clocks
>
>On Fri, Jul 18, 2014 at 07:01:38PM +0200, Stefan Agner wrote:
>> This commit adds PLL7 which is required for USBPHY1. It also adds the
>> USB PHY and USB Controller clocks and the gates to enable them.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>
>Jingchang,
>
>Does the patch look good to you?
>
>Shawn
>
For the clk creation, I think it is ok if the functionality has been tested, thanks!

Acked-by: Jingchang Lu <jingchang.lu@freescale.com>


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
