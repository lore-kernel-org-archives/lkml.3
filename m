Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaGJJo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:44:58 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:56924
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751517AbaGJJoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:44:55 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: Harini Katakam <harinikatakamlinux@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>,
        =?utf-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Geert Uytterhoeven" <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
Thread-Topic: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
Thread-Index: AQHPnBwMDKcQHlNM6UOuACq56TIA95uYgWiAgAADs4CAAIgF4A==
Date: Thu, 10 Jul 2014 09:44:44 +0000
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
	<CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
 <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
In-Reply-To: <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.92.172]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <bc4868b5-1b8a-44e1-af6a-595be5fd899b@BN1BFFO11FD058.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(13464003)(24454002)(377454003)(51704005)(4396001)(85852003)(93886003)(81542001)(46102001)(106466001)(87936001)(31696002)(50986999)(31966008)(47776003)(19580395003)(76176999)(92566001)(64706001)(50466002)(54356999)(104016003)(53416004)(74502001)(81342001)(77096002)(74662001)(23676002)(76482001)(85306003)(106116001)(2656002)(1496007)(83322001)(19580405001)(6806004)(107046002)(77982001)(79102001)(44976005)(95666004)(20776003)(70736001)(33646001)(99396002)(21056001)(86362001)(83072002)(80022001)(92726001)(74316001)(107986001)(23106004)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0268246AE7
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6A9jAhN007322

HI Greet,

>-----Original Message-----
>From: Harini Katakam [mailto:harinikatakamlinux@gmail.com]
>Sent: Thursday, July 10, 2014 3:01 PM
>To: Geert Uytterhoeven
>Cc: Mark Brown; Grant Likely; Rob Herring; Pawel Moll; Mark Rutland; Ian
>Campbell; Kumar Gala; linux-spi; linux-kernel@vger.kernel.org;
>devicetree@vger.kernel.org; linux-doc@vger.kernel.org; David Woodhouse;
>Brian Norris; Marek VaÅ¡ut; Artem Bityutskiy; Geert Uytterhoeven; Sascha
>Hauer; Jingoo Han; Sourav Poddar; Michal Simek; Punnaiah Choudary Kalluri
>Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
>
>Hi Geert,
>
>On Thu, Jul 10, 2014 at 2:48 PM, Geert Uytterhoeven
><geert@linux-m68k.org> wrote:
>> Hi Harini,
>>
>> On Thu, Jul 10, 2014 at 10:50 AM, Harini Katakam <harinik@xilinx.com>
>wrote:
>>> +       master->flags = SPI_MASTER_QUAD_MODE;
>>
>> SPI_MASTER_QUAD_MODE is not one of the SPI_MASTER_* defines
>> in include/linux/spi/spi.h?
>>
>
>I'm sorry about that. That flag is unused - will remove this statement.
>
>>> +       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL |
>SPI_RX_QUAD |
>>> +                           SPI_TX_DUAL | SPI_TX_QUAD;
>>
>> Your driver advertises Dual/Quad SPI Transfer capabilities, but it doesn't
>> check spi_transfer.[tr]x_nbits? How can it determine when to enable
>Dual/Quad?
>>
>
>Here the driver is just giving information that the controller support it.
>The MTD layer enables dual/quad based on what the flash supports; quad
>being the first priority
>I understand that the spi core reads rx, tx-bus-width property and
>master support flags and
>performs the necessary checks.

Just to add, the zynq qspi controller will automatically select the IO lines based
On the flash command. 

Regards,
Punnaiah

>
>Regards,
>Harini
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
