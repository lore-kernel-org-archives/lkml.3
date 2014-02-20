Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaBTOMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:12:36 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63327 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaBTOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1402201448070.1192@pobox.suse.cz>
References: <1392136001-913-1-git-send-email-richard.genoud@gmail.com> <alpine.LNX.2.00.1402201448070.1192@pobox.suse.cz>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 20 Feb 2014 15:12:12 +0100
Message-ID: <CACQ1gAi4dLtU+WrqvHk4EdVw4-Bg7O6q4BNAKnxhcpxX2h6pag@mail.gmail.com>
Subject: Re: [PATCH] trivial: gpiolib: typo in gpiochip_is_requested comment
To: Jiri Kosina <jkosina@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-20 14:48 GMT+01:00 Jiri Kosina <jkosina@suse.cz>:
> On Tue, 11 Feb 2014, Richard Genoud wrote:
>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>  drivers/gpio/gpiolib.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 80da9f1940c9..a0b96695c519 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1646,7 +1646,7 @@ void gpio_free_array(const struct gpio *array, size_t num)
>>  EXPORT_SYMBOL_GPL(gpio_free_array);
>>
>>  /**
>> - * gpiochip_is_requested - return string iff signal was requested
>> + * gpiochip_is_requested - return string if signal was requested
>
> Why do you believe this is correct, please?

damned ! I thought that iff was a typo... I didn't know that it meant
"if and only if"
sorry... please drop this.

Richard.
