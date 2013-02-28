Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3B1IZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:25:11 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36544
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab3B1IZJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:25:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 19
X-BigFish: VS19(z3121kz98dIc89bh936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h133w1155h)
Message-ID: <512F146F.6000608@freescale.com>
Date: Thu, 28 Feb 2013 16:25:19 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>	 <1359349039-11510-2-git-send-email-b32955@freescale.com> <1360684037.12703.117.camel@sauron.fi.intel.com>
In-Reply-To: <1360684037.12703.117.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月12日 23:47, Artem Bityutskiy 写道:
> On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
>> +       {"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },
>> +       {"SmartMedia 256MiB 3,3V ROM",  {0, 0x5b}, 512, 256, 0x4000,
>> NAND_ROM},
> Sorry for a possibly stupid question, but what does it buy you adding
> another "0" to all the entries? I see you add another table, which you
> look up if the "traditional" table does not work. Why you need to add
> these zeroes?
>
just a ping.

are we missing the merge window again?

thanks
Huang Shijie

