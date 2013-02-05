Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3BEIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:21:37 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:28115
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab3BEIVg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:21:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIc89bh146fI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h1155h)
Message-ID: <5110C10B.5090502@freescale.com>
Date: Tue, 5 Feb 2013 16:21:31 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ricard Wanderlof <ricard.wanderlof@axis.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 2/2] mtd: torturetest: add the support for random data
 pattern
References: <1360030820-21491-1-git-send-email-b32955@freescale.com> <1360030820-21491-2-git-send-email-b32955@freescale.com> <alpine.DEB.2.00.1302050900010.3736@lnxricardw.se.axis.com>
In-Reply-To: <alpine.DEB.2.00.1302050900010.3736@lnxricardw.se.axis.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月05日 16:05, Ricard Wanderlof 写道:
>
> On Tue, 5 Feb 2013, Huang Shijie wrote:
>
>> Add a new module parameter 'pattern'. If it is set to zero, we will 
>> use the 55/AA pattern to torture the nand blocks; if it is set to a 
>> non-zero value, we will use the random data pattern.
>
> Not a big issue in any way, but if you're using a numeric parameter 
> value anyway, could not one use a range of the permissable values to 
> set a seed for the random generation, so that the test can be repeated 
> with the same set of random numbers?
It's ok to provide a seed to the mtd_torturetest.


>
> Something like
>
> 0 => 55/AA
> -1 => random
> 1 and up => random, specifying seed for random number generator.
>
I will add it in next version.

thanks for your review.

Huang Shijie



