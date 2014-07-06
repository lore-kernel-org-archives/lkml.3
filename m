Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaGFNXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 09:23:24 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40209 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGFNXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 09:23:22 -0400
Message-ID: <53B94DC6.7070308@gmail.com>
Date: Sun, 06 Jul 2014 18:53:18 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varka Bhadram <varkab@cdac.in>
Subject: Re: [PATCH v2] drivers/gpio/gpio-sch311x: check return value of gpiochip_remove()
References: <1404457379-4193-1-git-send-email-varkab@cdac.in> <CAAVeFuK8oQStjAozf_3e3YTWBx3JYzBxEvLUq6n6uke1qaxXvg@mail.gmail.com>
In-Reply-To: <CAAVeFuK8oQStjAozf_3e3YTWBx3JYzBxEvLUq6n6uke1qaxXvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 06 July 2014 02:52 PM, Alexandre Courbot wrote:
> On Fri, Jul 4, 2014 at 4:02 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
>> This patch eliminates the following warning
>>
>> drivers/gpio/gpio-sch311x.c: In function ‘sch311x_gpio_probe’:
>> drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result
> gpiochip_remove() is to have its return value set to void in another
> patch, so I'm not sure we need this one in the meantime?

I also saw that patch from abdoulaye berthe<berthe.ab@gmail.com>  .

If that is accepted its good. If not this may require.

-- 
Regards,
Varka Bhadram

