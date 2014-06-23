Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaFWKb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:31:57 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43226 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaFWKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:31:55 -0400
Message-ID: <53A80215.5090200@gmail.com>
Date: Mon, 23 Jun 2014 18:31:49 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <alpine.DEB.2.02.1406230237330.8821@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406230237330.8821@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/23/2014 05:38 PM, David Rientjes wrote:
> On Sun, 22 Jun 2014, Chen Gang wrote:
> 
>> diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
>> index f59771a..7a0ead9 100644
>> --- a/arch/score/include/uapi/asm/ptrace.h
>> +++ b/arch/score/include/uapi/asm/ptrace.h
>> @@ -4,16 +4,16 @@
>>  #define PTRACE_GETREGS		12
>>  #define PTRACE_SETREGS		13
>>  
>> -#define PC		32
>> -#define CONDITION	33
>> -#define ECR		34
>> -#define EMA		35
>> -#define CEH		36
>> -#define CEL		37
>> -#define COUNTER		38
>> -#define LDCR		39
>> -#define STCR		40
>> -#define PSR		41
>> +#define SCORE_PC		32
>> +#define SCORE_CONDITION		33
>> +#define SCORE_ECR		34
>> +#define SCORE_EMA		35
>> +#define SCORE_CEH		36
>> +#define SOCRE_CEL		37
> 
> SOCRE?
> 

OH, typo issue, thanks.

>> +#define SCORE_COUNTER		38
>> +#define SCORE_LDCR		39
>> +#define SCORE_STCR		40
>> +#define SCORE_PSR		41
>>  
>>  #define SINGLESTEP16_INSN	0x7006
>>  #define SINGLESTEP32_INSN	0x840C8000
> 
> This is a uapi header file, what was done to ensure this doesn't introduce 
> userspace breakage?
> 

Do you have any new idea for it, since you have question?


For me, one solving way is: use "#if defined(__KERNEL__) &&
defined(__LINUX__)" for check whether need a prefix (e.g. 'SCORE_') for it.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
