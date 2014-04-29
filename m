Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbaD2JhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:37:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43851 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbaD2JhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:37:05 -0400
Message-ID: <535F72B5.3000405@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 15:06:53 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, x86@kernel.org
CC: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V3 2/2] powerpc/pseries: init fault_around_order for pseries
References: <1398675690-16186-1-git-send-email-maddy@linux.vnet.ibm.com> <1398675690-16186-3-git-send-email-maddy@linux.vnet.ibm.com> <877g686fpb.fsf@rustcorp.com.au>
In-Reply-To: <877g686fpb.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042909-1618-0000-0000-000000277A13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2014 07:48 AM, Rusty Russell wrote:
> Madhavan Srinivasan <maddy@linux.vnet.ibm.com> writes:
>> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
>> index 2db8cc6..c87e6b6 100644
>> --- a/arch/powerpc/platforms/pseries/setup.c
>> +++ b/arch/powerpc/platforms/pseries/setup.c
>> @@ -74,6 +74,8 @@ int CMO_SecPSP = -1;
>>  unsigned long CMO_PageSize = (ASM_CONST(1) << IOMMU_PAGE_SHIFT_4K);
>>  EXPORT_SYMBOL(CMO_PageSize);
>>  
>> +extern unsigned int fault_around_order;
>> +
> 
> It's considered bad form to do this.  Put the declaration in linux/mm.h.
> 

ok. Will change it.

Thanks for review
With regards
Maddy

> Thanks,
> Rusty.
> PS.  But we're getting there! :)
> 

