Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3EOHgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:36:22 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:8775 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704Ab3EOHgV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:36:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIc89bh936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <51933B79.5000608@freescale.com>
Date: Wed, 15 May 2013 15:38:33 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 1/9] mtd: add more comment for ecc_strength/ecc_size
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>	 <1366967337-5534-2-git-send-email-b32955@freescale.com> <1368602870.13665.7.camel@sauron.fi.intel.com>
In-Reply-To: <1368602870.13665.7.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月15日 15:27, Artem Bityutskiy 写道:
> On Fri, 2013-04-26 at 17:08 +0800, Huang Shijie wrote:
>> Add more commit for ecc_strength and ecc_size fields.
>> We can treat the comment as the initial semantics for the two fields.
>>
>> Signed-off-by: Huang Shijie<b32955@freescale.com>
> Huang, let me drop the 3 patches I already merged. Please, re-send them
> in v5. I think this is better because I see you start applying patches
> on top of them, which is a bit confusing.
>
Ok, Please drop the 3 patches.

>>    * @cellinfo:		[INTERN] MLC/multichip data from chip ident
>>    * @ecc_strength:	[INTERN] ECC correctability from the datasheet.
>> + *			The minimum number of bits correctability, if known;
>> + *			if unknown, set to 0.
> I find this confusing still. How about this comment.
>
> ECC correctability from the datasheet. Minumum amount of bit errors per
> @ecc_size guaranteed to be correctable). If unknown, set to zero.
>
>
it's okay to me.
>>    * @ecc_size:		[INTERN] ECC size required by the @ecc_strength,
>> - *                      also from the datasheet.
>> + *                      also from the datasheet. It is the recommended ECC step
>> + *			size, if known; if unknown, set to 0.
> Silly question, why you call this one "ecc_size", and not "ecc_step"?
>
In nand_ecc_ctrl{}, the ecc step is named to @size.

Personally, i perfer to ecc_step.


thanks
Huang Shijie



