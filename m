Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaBFOHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:07:40 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50572 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaBFOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:07:20 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F39718.9070205@roeck-us.net>
Date: Thu, 06 Feb 2014 06:07:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jdelvare@suse.de,
        lm-sensors@lm-sensors.org
Subject: Re: randconfig build error with next-20140206, in drivers/hwmon/ltc2945.c
References: <CA+r1ZhgB-DpgshX24HmzuqZPQr5wsueg4GYACy-669RmTL4xRA@mail.gmail.com>
In-Reply-To: <CA+r1ZhgB-DpgshX24HmzuqZPQr5wsueg4GYACy-669RmTL4xRA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 05:57 AM, Jim Davis wrote:
> Building with the attached random configuration file,
>
> drivers/built-in.o: In function `ltc2945_set_value':
> ltc2945.c:(.text+0x58b1ad): undefined reference to `__udivdi3'
> ltc2945.c:(.text+0x58b1cc): undefined reference to `__udivdi3'
> ltc2945.c:(.text+0x58b1dd): undefined reference to `__udivdi3'
> ltc2945.c:(.text+0x58b1fb): undefined reference to `__udivdi3'
> make: *** [vmlinux] Error 1
>

I really love those auto-builders :-)

Should be fixed in the next version of -next.

Guenter

