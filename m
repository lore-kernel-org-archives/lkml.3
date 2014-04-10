Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaDJOOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:14:40 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:57697 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934712AbaDJOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:14:37 -0400
MIME-Version: 1.0
In-Reply-To: <000701cf54a2$7c1379c0$743a6d40$%han@samsung.com>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-2-git-send-email-acourbot@nvidia.com> <CAAVeFu+XUzZ7ozMOcp6A-gZJ9o8DZFrdh1j4LvCQtoTcu=PP1g@mail.gmail.com>
 <000701cf54a2$7c1379c0$743a6d40$%han@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 10 Apr 2014 23:14:16 +0900
Message-ID: <CAAVeFuKJnSk2XSsMZZKMfyabzJ5CYdqWdE91H5uHiYFC1r6HxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
To: Jingoo Han <jg1.han@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Bryan Wu <cooloney@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 6:51 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, April 10, 2014 1:17 PM, Alexandre Courbot wrote:
>>
>> Ping, can I have the Samsung folks review and ,aybe even merge this
>> patch? enable_gpio_flags is never used in any code, is replaced by
>> gpiod, and we would like to remove it altogether from pwm_bl. Thanks!
>
> OK, I see. It looks good.
>
> As far as I know, 'enable_gpio_flags' has not been being used
> for Samsung platform. So, there will be no side effect,
> if 'enable_gpio_flags' is removed from 'arch/arm/plat-samsung'
> directory.
>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Great, thanks. Ben, Kukjin, could we have your Acked-by?

Thierry, if the Samsung maintainers are ok with it, and 2/2 of this
series is also ok for you (you merged the same for simple-panel
already), can you take both into your tree?

Thanks,
Alex.
