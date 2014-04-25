Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaDYUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:42:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42427 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaDYUmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:42:22 -0400
Message-ID: <535AC8A9.9030303@infradead.org>
Date: Fri, 25 Apr 2014 13:42:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>, Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>, jon@ringle.org
Subject: Re: [PATCH 1/2] serial: sc16is7xx: depend on I2C
References: <1398455590-4374-1-git-send-email-jon@ringle.org> <1398457576.792048107@f368.i.mail.ru> <20140425203528.GA15154@kroah.com> <1398458399.164274248@f343.i.mail.ru>
In-Reply-To: <1398458399.164274248@f343.i.mail.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/14 13:39, Alexander Shiyan wrote:
> Fri, 25 Apr 2014 13:35:28 -0700 от Greg KH <gregkh@linuxfoundation.org>:
>> On Sat, Apr 26, 2014 at 12:26:16AM +0400, Alexander Shiyan wrote:
>>> Fri, 25 Apr 2014 13:23:15 -0700 от Greg KH <gregkh@linuxfoundation.org>:
>>>> On Fri, Apr 25, 2014 at 03:53:09PM -0400, jon@ringle.org wrote:
>>>>> From: Jon Ringle <jringle@gridpoint.com>
>>>>>
>>>>> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
>>>>> ---
>>>>>  drivers/tty/serial/Kconfig | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>>>>> index c3e2b32..64c5659 100644
>>>>> --- a/drivers/tty/serial/Kconfig
>>>>> +++ b/drivers/tty/serial/Kconfig
>>>>> @@ -1180,6 +1180,7 @@ config SERIAL_SCCNXP_CONSOLE
>>>>>  
>>>>>  config SERIAL_SC16IS7XX
>>>>>  	tristate "SC16IS7xx serial support"
>>>>> +	depends on I2C
>>>>>  	select SERIAL_CORE
>>>>>  	select REGMAP_I2C if I2C
>>>>>  	help
>>>>> -- 
>>>>> 1.8.5.4
>>>>
>>>> Better, but I still have the build warnings :(
>>>
>>> I hope not same as before?
>>
>> Exactly the same.
> 
> Hmm...
> 
> In the source:
> #ifdef CONFIG_REGMAP_I2C
> Should be of course #ifdef CONFIG_I2C
> But this should not provide such warnings...

Can I see the warnings and .config file that causes them?


-- 
~Randy
