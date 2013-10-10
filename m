Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3JJHfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:35:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49365 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3JJHfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:35:31 -0400
X-Spam-Score: -100.8
Message-ID: <52565885.5030902@asianux.com>
Date: Thu, 10 Oct 2013 15:34:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] s390: include: asm: atomic.h: use 'unsigned int'
 instead of 'unsigned long' for atomic_*_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com> <20131010072508.GA4383@osiris>
In-Reply-To: <20131010072508.GA4383@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 03:25 PM, Heiko Carstens wrote:
> On Thu, Oct 10, 2013 at 10:31:22AM +0800, Chen Gang wrote:
>> The type of 'v->counter' is always 'int', and related inline assembly
>> code also process 'int', so use 'unsigned int' instead of 'unsigned
>> long' for the 'mask'.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/s390/include/asm/atomic.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
>> index a62ed2d..12c5ec1 100644
>> --- a/arch/s390/include/asm/atomic.h
>> +++ b/arch/s390/include/asm/atomic.h
>> @@ -113,12 +113,12 @@ static inline void atomic_add(int i, atomic_t *v)
>>  #define atomic_dec_return(_v)		atomic_sub_return(1, _v)
>>  #define atomic_dec_and_test(_v)		(atomic_sub_return(1, _v) == 0)
>>
>> -static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
>> +static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
>>  {
> 
> Applied. Thanks!
> 
> 
> 

Thank you very much!!

-- 
Chen Gang
