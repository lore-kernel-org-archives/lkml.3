Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaDGV1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:27:19 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:38403 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaDGV1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAKSnaae5onmE4QnvTnN7TSC9iLb4DLaL561GMMsDwaPxzd8jTw@mail.gmail.com>
References: <1396754381.13341.4.camel@phoenix> <20140406093053.GH12170@pengutronix.de>
 <CAFRkauBRAmCpF+84bRhqB3hJinnt0apo4dpV+VfUELVXSr8+rg@mail.gmail.com> <CAKSnaae5onmE4QnvTnN7TSC9iLb4DLaL561GMMsDwaPxzd8jTw@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 7 Apr 2014 14:26:17 -0700
Message-ID: <CAK5ve-JjFShyyLys3ZNVa4s+y1+ac-oDYraC8vF+H1rEnDSfxQ@mail.gmail.com>
Subject: Re: [PATCH RFC] leds: pca9685: Remove leds-pca9685 driver
To: =?ISO-8859-1?Q?Maximilian_G=FCntner?= 
	<maximilian.guentner@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 6, 2014 at 4:12 AM, Maximilian Güntner
<maximilian.guentner@gmail.com> wrote:
> 2014-04-06 12:40 GMT+02:00 Axel Lin <axel.lin@ingics.com>:
>> 2014-04-06 17:30 GMT+08:00 Steffen Trumtrar <s.trumtrar@pengutronix.de>:
>>> Hi!
>
> Hello,
>
>>> This confused me for a second, as there was no driver to replace when I wrote
>>> the pwm-pca9685 driver and I thought I missed something. But it seems I didn't
>>> and the pwm-pca9685 is actually older.
>>
>> Ah.. right, leds-pca9685 is a newer driver.
>>
>> 2013-10-22 leds: Added driver for the NXP PCA9685 I2C chip
>> 2013-05-30 pwm: add pca9685 driver
>>
> True. I wrote this driver in April 2013 since there was no driver
> available for the PCA9685 at this point.
> When I submitted it in October I only checked 'drivers/leds/' for
> support but not 'drivers/pwm'.
>
>>>
>>>> Use git grep to check current tree and found there is no user uses leds-pca9685.
>>>> So this patch removes leds-pca9685 driver.
>>>>
>>>
>>> If the platform setup is needed, maybe this can be integrated into the pwm driver
>>> instead of completely dropping it. I don't care for platform code, but if someone
>>> does, I don't want him to lose the support for it.
>>
>> Given the fact there is no user in current tree uses leds-pca9685,
>> I suspect if we need to add platform setup to pwm-pca9685.
>> ( I think the trend is to use DT, not the reverse )
>>
>>>
>>> Otherwise I am okay with this drop (okay, I'm completely biased of course ;-)).
>>> But technically the pca9685 is not solely a LED driver IC, but a PWM IC, so it
>>> is in the wrong place anyhow.
>>
>> I also think PWM subsystem is better for this chip which is a PWM IC.
> +1
>
> I also ACK the drop of leds-pca9685 in favor of pwm-pca9685.
>
> Thanks,
>
> Maximilian

OK, great, I will merge this change with Maximilian and Steffen's acks.

Thanks,
-Bryan
