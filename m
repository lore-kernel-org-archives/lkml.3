Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3EWF0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:26:03 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44971 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3EWFZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <519D3594.4070305@kernel.org>
References: <1369031689-23189-1-git-send-email-ch.naveen@samsung.com>
 <CAD=FV=Xppyb+Y0atygnwA8oBHmGHDx7Bit2fN12GX5Tt-Y9H1A@mail.gmail.com> <519D3594.4070305@kernel.org>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 23 May 2013 10:55:39 +0530
Message-ID: <CAHfPSqD0zpR3dRDaH4c3uxHS81vYn6mPyNjCmJ6c-TC1wpZeig@mail.gmail.com>
Subject: Re: [PATCH] iio: exynos_adc: fix wrong structure extration in suspend
 and resume
To: Jonathan Cameron <jic23@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2013 02:46, Jonathan Cameron <jic23@kernel.org> wrote:
> On 05/20/2013 06:09 PM, Doug Anderson wrote:
>> Naveen,
>>
>> On Sun, May 19, 2013 at 11:34 PM, Naveen Krishna Chatradhi
>> <ch.naveen@samsung.com> wrote:
>>> The exynos_adc device structure was wrongly extracted from the dev*
>>> correcting the same.
>>>
>>> Using the regular conversion of
>>> struct device* -> struct platform_device* -> struct exynos_adc* seems wrong.
>>> Instead we should be doing
>>> struct device* -> struct iio_dev* -> struct exynos_adc*
>>>
>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>> ---
>>>  drivers/iio/adc/exynos_adc.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Applied to the fixes-togreg branch of iio.git
> I'll hopefully send these on to Greg before the weekend.
Jonathan,

I would like to know any comments on

https://patchwork.kernel.org/patch/2513361/

Its been pending for a while now.

Thanks,
Naveen

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



--
Shine bright,
(: Nav :)
