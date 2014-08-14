Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaHNPRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:17:13 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50617 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaHNPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:17:11 -0400
Message-ID: <53ECD2EE.6020101@codethink.co.uk>
Date: Thu, 14 Aug 2014 16:17:02 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH 1/5] gpiolib: devres: Introduce the function devm_request_gpio_array
References: <cover.1404665589.git.himangi774@gmail.com>	<1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>	<53BD2509.6070803@codethink.co.uk>	<CACRpkdZWfYN14aki-UqvWp1K0exVj-mMK92q431QueSVvjZFuA@mail.gmail.com>	<53BE7288.6060503@codethink.co.uk>	<CABxcv=mhMMQxqVRM28NucnSW62v_3ghnT58JqFxvK=2bjxizdw@mail.gmail.com>	<53BFB659.8050306@codethink.co.uk> <CABxcv==adT6YPEekjD1y3ncrj9ghWE8UMuc64AeVWCPVb0ywFw@mail.gmail.com>
In-Reply-To: <CABxcv==adT6YPEekjD1y3ncrj9ghWE8UMuc64AeVWCPVb0ywFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid too many other things have been landing on my plate and I
don't think I will be able to get on this for the foreseeable future,
sorry about this.

On 11/07/14 11:07, Javier Martinez Canillas wrote:
> Hello Rob,
>
> On Fri, Jul 11, 2014 at 12:03 PM, Rob Jones <rob.jones@codethink.co.uk> wrote:
>>
>>
>> On 11/07/14 01:35, Javier Martinez Canillas wrote:
>>>
>>> Hello Rob,
>>>
>>> On Thu, Jul 10, 2014 at 1:01 PM, Rob Jones <rob.jones@codethink.co.uk>
>>> wrote:
>>
>>
>> <snip>
>>
>>
>>>>
>>>> I will certainly consider it. I'm in the middle of something else right
>>>> now but I should be available in a day or two and I'll have a look.
>>>>
>>>>
>>>
>>> I'm working on a driver for a PMIC which uses a set of GPIO to select
>>> a particular register. Right now I'm getting each GPIO independently
>>> but Linus mentioned [0] the devm_gpio_request_array() patch you
>>> posted.
>>>
>>> Now, I'm not using the integer-based GPIO API but the new
>>> descriptor-based one so I was wondering if you are already
>>> implementing a devm_gpiod_get_array() or if you want me to implement
>>> it myself.
>>>
>>
>> As I said, I'm deep in something else for the next day or two so if you
>> need it urgently you should probably do it yourself but if you don't
>> mind waiting until next week, I can have a go.
>>
>> Your call, let me know.
>>
>
> I'm not in a hurry, just wanted to know if it was on your plate. I'll
> wait for your patch then, thanks!
>
> Best regards,
> Javier
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
