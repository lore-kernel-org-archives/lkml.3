Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3DVFJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:09:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56086 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3DVFJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:09:09 -0400
X-Spam-Score: -100.8
Message-ID: <5174C5C6.5010206@asianux.com>
Date: Mon, 22 Apr 2013 13:08:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] ARM64: kernel: compiling issue, need implement cmpxchg64
 with assembler language.
References: <51712E5E.2020809@asianux.com> <201304191412.54601.arnd@arndb.de> <5171FD67.2080104@asianux.com> <2182812.ymprEm6XBb@wuerfel>
In-Reply-To: <2182812.ymprEm6XBb@wuerfel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月20日 15:32, Arnd Bergmann wrote:
> On Saturday 20 April 2013 10:28:55 Chen Gang wrote:
>>
>> -------------------------------patch begin--------------------------------------
>>
>> diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
>> index 968b5cb..b572d2b 100644
>> --- a/arch/arm64/include/asm/cmpxchg.h
>> +++ b/arch/arm64/include/asm/cmpxchg.h
>> @@ -170,4 +170,6 @@ static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
>>                                        (unsigned long)(n),              \
>>                                        sizeof(*(ptr))))
>>  
>> +#define cmpxchg64(ptr,o,n)     cmpxchg((ptr),(o),(n))
>> +
>>  #endif /* __ASM_CMPXCHG_H */
> 
> Yes, this looks good. Please provide the same for cmpxchg64_local.
> 

  ok, thanks, I will send related patch.


gchen.

