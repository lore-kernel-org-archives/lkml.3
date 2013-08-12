Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab3HLPRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:17:54 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38853 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab3HLPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:17:51 -0400
Message-ID: <5208FCB1.9080009@atmel.com>
Date: Mon, 12 Aug 2013 17:18:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: at91: choose appropriate handler for level interrupts
References: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com> <CACRpkdaGdgLeYrahv0qAJJjL3S2aiZeVwRVUtNcDqQgL3_mQkA@mail.gmail.com>
In-Reply-To: <CACRpkdaGdgLeYrahv0qAJJjL3S2aiZeVwRVUtNcDqQgL3_mQkA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/2013 17:42, Linus Walleij :
> On Sat, Jul 20, 2013 at 4:51 PM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>
>> The current implementation handle both edge and level interrupts with the
>> 'handle_simple_irq' handler.
>>
>> Level interrupts are active as long as the pin stays at the configured
>> level (low or high). In this case we have to use 'handle_level_irq' which
>> mask the interrupt until the handle has treated it.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Nicolas/Jean-Christophe: any opinion on this patch?

Back online:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

(maybe too late though)

Thanks for fixing this.

Bye,

> I am tempted to just apply it and see if you react to it :-)
>
> Yours,
> Linus Walleij
>


-- 
Nicolas Ferre
