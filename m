Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaAHOIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:08:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54684 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbaAHOIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:08:48 -0500
Message-ID: <52CD5BD8.8090903@ti.com>
Date: Wed, 8 Jan 2014 09:08:24 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v3 0/2] gpio: davinci: reuse for keystone arch
References: <1387885284-8119-1-git-send-email-grygorii.strashko@ti.com> <52CC3EDC.7070404@ti.com> <52CCCEB6.9050006@ti.com>
In-Reply-To: <52CCCEB6.9050006@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014 11:06 PM, Sekhar Nori wrote:
> On Tuesday 07 January 2014 11:22 PM, Santosh Shilimkar wrote:
>> Sekhar,
>>
>> On Tuesday 24 December 2013 06:41 AM, Grygorii Strashko wrote:
>>> This series is intended to update Davinci GPIO driver and reuse
>>> it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
>>> Keystone GPIO IP: supports:
>>> - up to 32 GPIO lines;
>>> - only unbanked irqs;
>>>
>>> See Documentation:
>>> Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>>>
>>> This series based on:
>>> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.14/gpio
>>>
>>> Changes in v3:
>>> - fixed code, changed by mistake; fixed sparse warning 
>>> Changes in v2:
>>> - minor comments applied, no functional changes
>>>
>>> v2: https://lkml.org/lkml/2013/12/18/135
>>> v1: https://lkml.org/lkml/2013/12/12/366
>>>
>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>> Cc: Alexandre Courbot <gnurou@gmail.com>
>>> Cc: Sekhar Nori <nsekhar@ti.com>
>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>
>>> Grygorii Strashko (2):
>>>   gpio: davinci: don't create irq_domain in case of unbanked irqs
>>>   gpio: davinci: reuse for Keystone SoC
>>>
>>>  .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
>>>  drivers/gpio/gpio-davinci.c                        |   82 ++++++++++++++------
>>>  2 files changed, 61 insertions(+), 25 deletions(-)
>>>
>> Have you picked up the $subject series in your queue ?
> 
> Not yet, at least on the new compatible introduction, I need an ack from
> DT folks.
> 
I noticed that but the usual 2 weeks period to get ack is over I guess ;-)
The DT part is really trivial as well but I let you decide.

> I am happy with the patches though and have tested them as well, In case
> I do not get an ack from 2/2 in time, I can at least send 1/2 for
> inclusion after my first gpio pull request to ARM-SoC gets pulled.
>
Would be great to get both of them but if not both at least 1/2.

Regards,
Santosh
 

