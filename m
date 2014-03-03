Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaCCI7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:59:12 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60518 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaCCI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:59:09 -0500
Message-ID: <5314439E.6070908@gmail.com>
Date: Mon, 03 Mar 2014 09:55:58 +0100
From: Jean-Jacques Hiblot <jjhiblot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
CC: James Hogan <james.hogan@imgtec.com>, grant.likely@linaro.org,
        linus.walleij@linaro.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup()
 from unsigned int to int
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com> <7150036.UpHTd1PK1K@radagast> <alpine.DEB.2.02.1403011629540.18573@ionos.tec.linutronix.de> <20140301160114.GE21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140301160114.GE21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Le 01/03/2014 17:01, Russell King - ARM Linux a écrit :
> On Sat, Mar 01, 2014 at 04:31:13PM +0100, Thomas Gleixner wrote:
>> On Fri, 28 Feb 2014, James Hogan wrote:
>>> On Thursday 27 February 2014 18:21:19 Jean-Jacques Hiblot wrote:
>>>>   drivers/irqchip/irq-metag.c               | 4 ++--
>>>
>>> I think you've missed out drivers/irqchip/irq-metag-ext.c
>>
>> There is a good reason why I asked to do this with coccinelle.
>
> Go easy, not everyone understands that complex tool - I certainly don't.
> I ended up deleting it from my system after several failed attempts, and
> I came to the conclusion that to use it properly, you also needed a Julia
> installed along side you to learn how to write its scripts.
>
> The big problem is it /doesn't/ do what it advertises to - I ended up
> writing expression after expression to make it detect all the various
> forms of what I wanted it to, which as I understand the tool is precisely
> the opposite of what you're supposed to do with it.
>
> I ended up coming to the conclusion that a well formed sed and/or grep
> expression was far more useful and effective than trying to figure out
> coccinelle.
>
Actually I tried to use coccinelle for this, but to paraphrase Thomas: 
it was a failure on its own. The tool is complex.
I'll send shortly a second version of the patch with the missing change(s).

Jean-Jacques
