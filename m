Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaCXMeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:34:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35325 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaCXMeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:34:11 -0400
Message-ID: <5330263D.8090005@gmail.com>
Date: Mon, 24 Mar 2014 20:34:05 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSF0gYXJjaC91bmljb3JlMzIvbW0vYWw=?=
 =?UTF-8?B?aWdubWVudC5jOiBpbmNsdWRlICJhc20vcGd0YWJsZS5oIiB0byBhdm9pZCBjb20=?=
 =?UTF-8?B?cGlsaW5nIGVycm9y?=
References: <1712256630.20489.1395664159391.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1712256630.20489.1395664159391.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/24/2014 08:29 PM, 管雪涛 wrote:
> Thanks,
> 
> Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>
> 

Thank you too.

> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> Need include "asm/pgtable.h" to include "asm-generic/pgtable-nopmd.h",
>> so can let 'pmd_t' defined. The related error with allmodconfig:
>>
>>     CC      arch/unicore32/mm/alignment.o
>>   In file included from arch/unicore32/mm/alignment.c:24:
>>   arch/unicore32/include/asm/tlbflush.h:135: error: expected ‘)’ before ‘*’ token
>>   arch/unicore32/include/asm/tlbflush.h:154: error: expected ‘)’ before ‘*’ token
>>   In file included from arch/unicore32/mm/alignment.c:27:
>>   arch/unicore32/mm/mm.h:15: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>>   arch/unicore32/mm/mm.h:20: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>>   arch/unicore32/mm/mm.h:25: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘*’ token
>>   make[1]: *** [arch/unicore32/mm/alignment.o] Error 1
>>   make: *** [arch/unicore32/mm] Error 2
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  arch/unicore32/mm/alignment.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
>> index de7dc5f..24e8360 100644
>> --- a/arch/unicore32/mm/alignment.c
>> +++ b/arch/unicore32/mm/alignment.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/sched.h>
>>  #include <linux/uaccess.h>
>>  
>> +#include <asm/pgtable.h>
>>  #include <asm/tlbflush.h>
>>  #include <asm/unaligned.h>
>>  
>> -- 
>> 1.7.9.5
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
