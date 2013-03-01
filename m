Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3CAJXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:23:45 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41129 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3CAJXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:23:43 -0500
MIME-Version: 1.0
In-Reply-To: <51304ABD.9020706@c-s.fr>
References: <201302220926.r1M9Q3wV029855@localhost.localdomain>
	<CACRpkdY1M8w7o8S4idAx1JN-fc-t221qF_uwR5U9RBsBAn=Jhw@mail.gmail.com>
	<51304ABD.9020706@c-s.fr>
Date: Fri, 1 Mar 2013 10:23:42 +0100
Message-ID: <CACRpkdZMxBGd-Tee1DjKZZLOx5kwxJ5GRmjZT7jZcGAR594WSg@mail.gmail.com>
Subject: Re: [PATCH] Adds support for Open Firmware in MAX730x GPIO Driver
From: Linus Walleij <linus.walleij@linaro.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 7:29 AM, leroy christophe
<christophe.leroy@c-s.fr> wrote:
> Le 01/03/2013 01:43, Linus Walleij a écrit :
>
>> On Fri, Feb 22, 2013 at 10:26 AM, Christophe Leroy
>> <christophe.leroy@c-s.fr> wrote:
>>
>>> This patch allows the use of the MAX730x Driver on systems using
>>> the Open Firmware platform format
>>>
>>> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> (...)
>>>
>>>          /* bits_per_word cannot be configured in platform data */
>>> -       spi->bits_per_word = 16;
>>> +       if (spi->dev.platform_data)
>>> +               spi->bits_per_word = 16;
>>
>> What about just fixing so you *can* specify that instead?
>> The comment looks more like a FIXME to me.
>
> Euh, ok, why not. But here the purpose of my patch is to allow using this
> driver with of_platform in addition to platform.
> This FIXME is not mine, it was already existing in that driver.
> As of_platform can configure bits per word, the only thing I did is to add a
> test in order to not apply this FIXME on the of_platform case.
>
> Do you think my patch is not acceptable like this ?

No big deal.

I was just taking this opportunity to try to push out some driver
maintenance, that's what subsystem maintainers do you know...

Yours,
Linus Walleij
