Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaI1KBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:01:15 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:55870
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751985AbaI1KBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:01:14 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: "Laurentiu.Tudor@freescale.com" <Laurentiu.Tudor@freescale.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>
CC: Scott Wood <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Topic: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Index: AQHP1wGYMBQEa9GSl0OI/HOhX0hHNpwR0gmAgARo4HA=
Date: Sun, 28 Sep 2014 10:01:10 +0000
Message-ID: <1760763ea8a0468e817d082f95e4016b@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
 <542410D3.2060507@freescale.com>
In-Reply-To: <542410D3.2060507@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB306;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(164054003)(51704005)(377454003)(479174003)(199003)(101416001)(64706001)(66066001)(50986999)(76176999)(54356999)(20776003)(83322001)(85306004)(19580405001)(87936001)(19580395003)(107046002)(83072002)(85852003)(108616004)(31966008)(21056001)(33646002)(74316001)(97736003)(76482002)(86362001)(92566001)(106116001)(106356001)(2656002)(4396001)(10300001)(90102001)(99396003)(80022003)(81542003)(74662003)(46102003)(74502003)(81342003)(77982003)(120916001)(76576001)(2501002)(95666004)(79102003)(105586002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB306;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8SA1Kiq008656

>-----Original Message-----
>From: Tudor Laurentiu-B10716
>Sent: Thursday, September 25, 2014 8:56 PM
>To: Lu Jingchang-B35083; mturquette@linaro.org
>Cc: Wood Scott-B07421; linuxppc-dev@lists.ozlabs.org; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
>CLK_OF_DECLARE support
>
>Hi Jingchang,
>
>On 09/23/2014 09:46 AM, Jingchang Lu wrote:
>> The IP is shared by PPC and ARM, this renames it to qoriq for better
>> represention, and this also adds the CLK_OF_DECLARE support for being
>> initialized by of_clk_init() on ARM.
>>
>
>I think you need to also update drivers/cpufreq/Kconfig.powerpc to use the
>renamed config option.
>

Thanks, I will update that selected config option of CLK_PPC_CORENET.

Best Regards,
Jingchang
>---
>Best Regards, Laurentiu


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
