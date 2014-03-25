Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaCYHM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:12:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36199 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCYHM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:12:27 -0400
Message-ID: <53312C53.3000801@gmail.com>
Date: Tue, 25 Mar 2014 15:12:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSF0gYXJjaC91bmljb3JlMzIvaW5jbHU=?=
 =?UTF-8?B?ZGUvYXNtL3B0cmFjZS5oOiBhZGQgZ2VuZXJpYyBkZWZpbml0aW9uIGZvciBwcm8=?=
 =?UTF-8?B?ZmlsZV9wYygp?=
References: <14860329.28442.1395730385637.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <14860329.28442.1395730385637.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 02:53 PM, 管雪涛 wrote:
> Thanks
> 
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> 

Thank you too.

> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> Add generic definition just like another architectures have done, or
>> can not pass compiling with allmodconfig, the related error:
>>
>>     CC      kernel/profile.o
>>   kernel/profile.c: In function ‘profile_tick’:
>>   kernel/profile.c:419: error: implicit declaration of function ‘profile_pc’
>>   make[1]: *** [kernel/profile.o] Error 1
>>   make: *** [kernel] Error 2
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/unicore32/include/asm/ptrace.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/unicore32/include/asm/ptrace.h b/arch/unicore32/include/asm/ptrace.h
>> index 9df53d9..02bf5a4 100644
>> --- a/arch/unicore32/include/asm/ptrace.h
>> +++ b/arch/unicore32/include/asm/ptrace.h
>> @@ -55,6 +55,7 @@ static inline int valid_user_regs(struct pt_regs *regs)
>>  
>>  #define instruction_pointer(regs)	((regs)->UCreg_pc)
>>  #define user_stack_pointer(regs)	((regs)->UCreg_sp)
>> +#define profile_pc(regs)		instruction_pointer(regs)
>>  
>>  #endif /* __ASSEMBLY__ */
>>  #endif
>> -- 
>> 1.7.9.5
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
