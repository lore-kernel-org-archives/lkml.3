Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3CEPnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:43:13 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:19879
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab3CEPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:43:10 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dIc89bh936eI1432I1447Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: =?utf-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
CC: Takashi Iwai <tiwai@suse.de>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
Thread-Topic: [PATCH] hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
Thread-Index: AQHOFEVlaCnzoxiyL0eFh8diNpI4WJiXBoCAgABBLIA=
Date: Tue, 5 Mar 2013 15:42:58 +0000
Message-ID: <1362498177.7780.13.camel@x230>
References: <s5h4ngz56yg.wl%tiwai@suse.de>
	 <5135DBD5.1070702@tremplin-utc.net>
In-Reply-To: <5135DBD5.1070702@tremplin-utc.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E758D63EA85ECA4C800FE9F9EBB4075C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r25FhFsc008161

On Tue, 2013-03-05 at 12:49 +0100, Ã‰ric Piel wrote:
> On 26/02/13 18:19, Takashi Iwai wrote:
> > The DriveGuard chips on the new HP laptops are with a new PnP ID
> > "HPQ6007".  It should be compatible with older chips.
> >
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Hi,
> Sorry for the delay. The driver is able to detect the actual type of 
> accelerometer behind, so indeed it should work fine.
> 
> Thanks for the patch, here is my:
> Acked-by: Ã‰ric Piel <eric.piel@tremplin-utc.net>
> 
> Matthew, could you pick this patch into your tree?

Will do.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
