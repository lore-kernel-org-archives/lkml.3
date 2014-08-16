Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaHPCVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 22:21:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52433 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHPCVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 22:21:47 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53EEC038.6070301@roeck-us.net>
Date: Fri, 15 Aug 2014 19:21:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xuetao Guan <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiBbUEFUQ0hdIHVuaWNvcmUzMjogRml4IGI=?=
 =?UTF-8?B?dWlsZCBlcnJvcg==?=
References: <207659056.258.1408149919386.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <207659056.258.1408149919386.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 05:45 PM, Xuetao Guan  wrote:
>
> ----- Guenter Roeck <linux@roeck-us.net> 写道：
>> On 08/10/2014 08:29 AM, Guenter Roeck wrote:
>>> unicore32 builds fail with
>>>
>>> arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
>>> arch/unicore32/kernel/signal.c:257: error:
>>> 			‘usig’ undeclared (first use in this function)
>>> arch/unicore32/kernel/signal.c:279: error:
>>> 			‘usig’ undeclared (first use in this function)
>>> arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
>>> arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
>>> arch/unicore32/kernel/signal.c: In function ‘do_signal’:
>>> arch/unicore32/kernel/signal.c:376: error:
>>> 			implicit declaration of function ‘get_signsl’
>>> make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
>>> make: *** [arch/unicore32/kernel/signal.o] Error 2
>>>
>>> Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
>>> signal_setup_done()").
>>>
>>> This code never even compiled. Reverting the patch does not work,
>>> since previously used functions no longer exist, so try to fix it up.
>>> Compile tested only.
>>>
>>> Cc: Richard Weinberger <richard@nod.at>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>
>> ping ...
>>
>> Failure is still present in upstream kernel (v3.16-11383-gc9d2642).
>>
>> Guenter
>>
>
> Thanks. I'll fix it.
>

More a question of applying (and if possible testing) the patch I provided.

Thanks,
Guenter


