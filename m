Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKYUbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKYUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:31:30 -0500
Message-ID: <5474E6C4.1000301@redhat.com>
Date: Tue, 25 Nov 2014 12:29:56 -0800
From: Alexander Duyck <alexander.h.duyck@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>
CC: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        peterz@infradead.org, benh@kernel.crashing.org,
        heiko.carstens@de.ibm.com, mingo@kernel.org, mikey@neuling.org,
        donald.c.skidmore@intel.com, matthew.vick@intel.com,
        geert@linux-m68k.org, jeffrey.t.kirsher@intel.com,
        romieu@fr.zoreil.com, paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com,
        arnd@arndb.de, will.deacon@arm.com, michael@ellerman.id.au,
        tony.luck@intel.com, torvalds@linux-foundation.org, oleg@redhat.com,
        schwidefsky@de.ibm.com, fweisbec@gmail.com, davem@davemloft.net
Subject: Re: [PATCH v6 5/5] patch to allow arm cross-compile
References: <20141125183009.1486.20845.stgit@ahduyck-server>	 <20141125183322.1486.90766.stgit@ahduyck-server> <1416944122.8358.10.camel@perches.com>
In-Reply-To: <1416944122.8358.10.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/25/2014 11:35 AM, Joe Perches wrote:
> (adding Russell King)
>
> On Tue, 2014-11-25 at 10:33 -0800, Alexander Duyck wrote:
>> ---
>>   arch/arm/kernel/asm-offsets.c |    4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
>> index 2d2d608..6f8e79c 100644
>> --- a/arch/arm/kernel/asm-offsets.c
>> +++ b/arch/arm/kernel/asm-offsets.c
>> @@ -49,10 +49,6 @@
>>   #error Your compiler is too buggy; it is known to miscompile kernels.
>>   #error    Known good compilers: 3.3, 4.x
>>   #endif
>> -#if GCC_VERSION >= 40800 && GCC_VERSION < 40803
>> -#error Your compiler is too buggy; it is known to miscompile kernels
>> -#error and result in filesystem corruption and oopses.
>> -#endif
>>   #endif

Sorry, that was for my testing only.  I will resubmit with that patch 
dropped.

Thanks,

Alex

