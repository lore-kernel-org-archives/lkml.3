Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3H0GHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:07:06 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:54319 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752914Ab3H0GG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:57 -0400
Message-ID: <521C41F7.8060305@gaisler.com>
Date: Tue, 27 Aug 2013 08:06:47 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com, tomasz.figa@gmail.com, swarren@wwwdotorg.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <201308261256.00870.poeschel@lemonage.de> <521B3C03.8080508@gaisler.com> <201308261604.55827.poeschel@lemonage.de>
In-Reply-To: <201308261604.55827.poeschel@lemonage.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-26 16:04, Lars Poeschel wrote:
> On Monday 26 August 2013 at 13:29:07, Andreas Larsson wrote:
>> On 2013-08-26 12:56, Lars Poeschel wrote:
>>>> This call to of_irq_find_parent breaks gpiolib-of for SPARC due to
>>>> the fact that the function is undefined when !defined(CONFIG_OF_IRQ)
>>>> && defined(CONFIG_OF).
>>>>
>>>> Defining the empty of_irq_find_parent in include/linux/of_irq.h when
>>>> !defined(CONFIG_OF_IRQ) instead of the current case when
>>>> !defined(CONFIG_OF) would solve the immediate compilation problem.
>>>
>>> Is this a bug and should be fixed ?
>>
>> Well, at least as soon as anyone tries to use in a context that does not
>> exclude SPARC it creates a bug, so I would say so. There is no reason
>> for SPARC to fall between the chairs. This is the first case I am aware
>> of that triggers this.
>
> I also think this should be fixed.
> Are you able to do a patch that fixes this and submit to the relevant
> people?

Sure!

Cheers,
Andreas

