Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3FYMeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:34:08 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54918 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3FYMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130625111718.GA18551@gondor.apana.org.au>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
	<CACRpkdYgZ5ZSwDBfV8FRRqGcv09JiFyNq18vqO_dbxbhJ6_x4w@mail.gmail.com>
	<20130625111718.GA18551@gondor.apana.org.au>
Date: Tue, 25 Jun 2013 14:34:05 +0200
Message-ID: <CACRpkdaVAbdMANkrqo2TK=z3JQ=KTdRxhR0f7zLTomuC7FFUrA@mail.gmail.com>
Subject: Re: [PATCH 0/6] Various ux500 crypto updates
From: Linus Walleij <linus.walleij@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 1:17 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jun 25, 2013 at 11:20:50AM +0200, Linus Walleij wrote:
>> On Tue, Jun 25, 2013 at 10:54 AM, Fabio Baltieri
>> <fabio.baltieri@linaro.org> wrote:
>>
>> > these are some fixes to issue pointed out by sparse and dmaengine API
>> > udpates on the recently enabled ux500 hw crypto drivers.
>>
>> The series:
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> > These are based on recent linux-next, and can probably be applied on an
>> > architecture specific branch with your ack, or just skip to the next
>> > merge window.
>>
>> I think these depend on the DMA40 fixes that reside in the ARM SoC
>> tree. If I get Herbert's ACK I can queue them.
>
> Sure,
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

OK I'll attempt to queue this up and send it to ARM SoC.

Yours,
Linus Walleij
