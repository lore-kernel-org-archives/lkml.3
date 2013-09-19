Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3ISQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:59:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:14732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3ISQ7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:59:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,938,1371106800"; 
   d="scan'208";a="405954400"
Message-ID: <523B2F57.2050504@linux.intel.com>
Date: Thu, 19 Sep 2013 10:07:35 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        gregkh@linuxfoundation.org, len.brown@intel.com, rjw@sisk.pl,
        arjan@linux.intel.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v1 5/6] bitops: Introduce BIT_ULL
References: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1379606435-15871-6-git-send-email-srinivas.pandruvada@linux.intel.com> <20130919164830.GB9427@pd.tnic>
In-Reply-To: <20130919164830.GB9427@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 09:48 AM, Borislav Petkov wrote:
> On Thu, Sep 19, 2013 at 09:00:34AM -0700, Srinivas Pandruvada wrote:
>> Adding BIT(x) equivalent for unsigned long long type, BIT_ULL(x).
>>
>> Suggested-by: Joe Perches <joe@perches.com>
>> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
>>   include/linux/bitops.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>> index a3b6b82..34e9e94 100644
>> --- a/include/linux/bitops.h
>> +++ b/include/linux/bitops.h
>> @@ -4,6 +4,7 @@
>>   
>>   #ifdef	__KERNEL__
>>   #define BIT(nr)			(1UL << (nr))
>> +#define BIT_ULL(nr)		(1ULL << (nr))
> We already have BIT_64 for that.
>
The current definition for BIT_64 is in arch/x86/include/asm/bitops.h. I 
feel it should be applicable for all architectures and move to some 
common file.

Thanks,
Srinivas
