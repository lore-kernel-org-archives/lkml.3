Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866Ab3IFRse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:48:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45182 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3IFRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:48:32 -0400
Message-ID: <522A156C.2070906@zankel.net>
Date: Fri, 06 Sep 2013 10:48:28 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] xtensa: Fix broken allmodconfig build
References: <1377662797-21770-1-git-send-email-linux@roeck-us.net> <52254FA2.8020407@roeck-us.net>
In-Reply-To: <52254FA2.8020407@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 9/2/13 7:55 PM, Guenter Roeck wrote:
> On 08/27/2013 09:06 PM, Guenter Roeck wrote:
>> xtansa allmodbuild fails with:
>>
>> arch/xtensa/kernel/xtensa_ksyms.c:129:1: error: '_mcount' undeclared 
>> here (not in a function)
>> make[2]: *** [arch/xtensa/kernel/xtensa_ksyms.o] Error 1
>> make[1]: *** [arch/xtensa/kernel] Error 2
>>
>> The breakage is due to commit 478ba61af (xtensa: add static function 
>> tracer
>> support) which exports _mcount without declaring it.
>>
>> Cc: Max Filippov <jcmvbkbc@gmail.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>
> Ping ... 3.11 now ships with xtensa allmodconfig broken, which is 
> completely unnecessary.
Sorry for the delay. I just added it to the xtensa for_next tree, and 
will push it upstream shortly.

Thanks,
-Chris
