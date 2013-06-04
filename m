Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab3FDG5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:57:03 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52511 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab3FDG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:56:59 -0400
Message-ID: <51AD8FB1.2020706@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:56:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, fenghua.yu@intel.com
Subject: Re: [PATCH] code clean in __flush_tlb_one()
References: <51AD8902.60603@linux.vnet.ibm.com> <51AD8F07.5060706@intel.com>
In-Reply-To: <51AD8F07.5060706@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-5816-0000-0000-00000843954C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 02:53 PM, Alex Shi wrote:
> On 06/04/2013 02:28 PM, Michael Wang wrote:
>> Remove the extra space in __flush_tlb_one()
> 
> It even don't need a reviewed-by. :)

Still thanks for your review :)

Regards,
Michael Wang

> 
> Thanks!
>>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Alex Shi <alex.shi@intel.com>
>> CC: Fenghua Yu <fenghua.yu@intel.com>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/tlbflush.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/tlbflush.h
>> b/arch/x86/include/asm/tlbflush.h
>> index 50a7fc0..cf51200 100644
>> --- a/arch/x86/include/asm/tlbflush.h
>> +++ b/arch/x86/include/asm/tlbflush.h
>> @@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
>>
>>  static inline void __flush_tlb_one(unsigned long addr)
>>  {
>> -		__flush_tlb_single(addr);
>> +	__flush_tlb_single(addr);
>>  }
>>
>>  #define TLB_FLUSH_ALL	-1UL
>>
> 
> 

