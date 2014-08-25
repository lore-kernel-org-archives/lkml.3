Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaHYROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:14:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHYROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:14:40 -0400
Message-ID: <53FB6EF1.4020805@infradead.org>
Date: Mon, 25 Aug 2014 10:14:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Proofread documentation
References: <1408956471-16579-1-git-send-email-geert+renesas@glider.be>	<53FB6B26.3030906@infradead.org> <CAMuHMdXOf8L5QpLdtpxkW1x7iA1hCGMuK+h_7NsKS0VvZDy6Mw@mail.gmail.com>
In-Reply-To: <CAMuHMdXOf8L5QpLdtpxkW1x7iA1hCGMuK+h_7NsKS0VvZDy6Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/14 10:10, Geert Uytterhoeven wrote:
> Hi Randy,
> 
> On Mon, Aug 25, 2014 at 6:58 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>>> -The load_uA value can be determined from the consumers datasheet. e.g.most
>>> -datasheets have tables showing the max current consumed in certain situations.
>>> +The load_uA value can be determined from the consumer's datasheet. e.g. most
>>
>> Prefer:                                                               E.g.
> 
> Me too. But the regulator docs consistently use full stops followed by
> lower-case abbreviations everywhere, so I kept them.

oh.  oh well, OK.
Thanks.

>> otherwise,
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert


-- 
~Randy
