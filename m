Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3JWH55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:57:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:42484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3JWH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:57:55 -0400
Message-ID: <5267817E.40906@atmel.com>
Date: Wed, 23 Oct 2013 08:57:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, "'Johan Hovold'" <jhovold@gmail.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] backlight: atmel-pwm-bl: fixes and clean ups
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com> <001801cecf8d$f3834d90$da89e8b0$%han@samsung.com>
In-Reply-To: <001801cecf8d$f3834d90$da89e8b0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/2013 02:19, Jingoo Han :
> On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
>>
>> These patches fix a few issues and clean up the atmel-pwm-bl driver
>> somewhat.
>>
>> Johan
>>
>> Johan Hovold (9):
>>    backlight: atmel-pwm-bl: fix reported brightness
>>    backlight: atmel-pwm-bl: fix gpio polarity in remove
>>    backlight: atmel-pwm-bl: fix module autoload
>>    backlight: atmel-pwm-bl: clean up probe error handling
>>    backlight: atmel-pwm-bl: clean up get_intensity
>>    backlight: atmel-pwm-bl: remove unused include
>>    backlight: atmel-pwm-bl: use gpio_is_valid
>>    backlight: atmel-pwm-bl: refactor gpio_on handling
>>    backlight: atmel-pwm-bl: use gpio_request_one
>
> ++cc Andrew Morton, Tomi Valkeinen, Jean-Christophe Plagniol-Villard
>
> Hi Johan Hovold,
>
> Currently, because there is no git tree for backlight,
> backlight patches have been merged to mm-tree by Andrew Morton.
> Please, add Andrew Morton to CC list.
>
> Also, there is another way.
> If Nicolas Ferre wants to merge these patches, the patches can be
> merged through ATMEL-SoC tree with my Acked-by.

Hi,

As it's a driver without interaction with AT91 code, maybe routing this 
patch series through mm-tree is the way to go.

If you find any issue in the process, please tell me. I would be happy 
to ease the process.

Bye,


>>
>>   drivers/video/backlight/atmel-pwm-bl.c | 86 ++++++++++++++++------------------
>>   1 file changed, 40 insertions(+), 46 deletions(-)
>
>


-- 
Nicolas Ferre
