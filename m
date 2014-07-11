Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaGKAfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:35:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59910 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaGKAfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:35:42 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.62.104]
In-Reply-To: <53BE7288.6060503@codethink.co.uk>
References: <cover.1404665589.git.himangi774@gmail.com>
	<1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>
	<53BD2509.6070803@codethink.co.uk>
	<CACRpkdZWfYN14aki-UqvWp1K0exVj-mMK92q431QueSVvjZFuA@mail.gmail.com>
	<53BE7288.6060503@codethink.co.uk>
Date: Fri, 11 Jul 2014 02:35:40 +0200
Message-ID: <CABxcv=mhMMQxqVRM28NucnSW62v_3ghnT58JqFxvK=2bjxizdw@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpiolib: devres: Introduce the function devm_request_gpio_array
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob,

On Thu, Jul 10, 2014 at 1:01 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>
> On 10/07/14 10:21, Linus Walleij wrote:
>>
>> On Wed, Jul 9, 2014 at 1:18 PM, Rob Jones <rob.jones@codethink.co.uk>
>> wrote:
>>
>>> Please note that I submitted a patch on 02/07/14 to create this
>>> function which was acked by Linus Walleij on 05/07/14.
>>>
>>> Great minds think alike, and all that.
>>
>>
>> My mind certainly isn't any great :-(
>>
>
> I doubt that :-)
>
>
>> My left hand seems to be unaware of what the right hand is doing.
>>
>> Did I ACK that for merging through some other tree then?
>>
>
> You did: https://lkml.org/lkml/2014/7/4/715
>
>
>> And I guess if Himangi want to submit these ASoC patches, they
>> will have to go through the same tree as those patches in that case?
>>
>
> I don't know enough to comment.
>
>
>> And would you consider implementing a gpiod version...?
>>
>
> I will certainly consider it. I'm in the middle of something else right
> now but I should be available in a day or two and I'll have a look.
>
>

I'm working on a driver for a PMIC which uses a set of GPIO to select
a particular register. Right now I'm getting each GPIO independently
but Linus mentioned [0] the devm_gpio_request_array() patch you
posted.

Now, I'm not using the integer-based GPIO API but the new
descriptor-based one so I was wondering if you are already
implementing a devm_gpiod_get_array() or if you want me to implement
it myself.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/7/10/166
