Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaGCBSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:18:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30643 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753911AbaGCBSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:18:12 -0400
X-IronPort-AV: E=Sophos;i="5.00,822,1396972800"; 
   d="scan'208";a="32764124"
Message-ID: <53B4AF87.7010502@cn.fujitsu.com>
Date: Thu, 3 Jul 2014 09:19:03 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] kvm: Add macro VMX_APIC_ACCESS_PAGE_ADDR
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-3-git-send-email-tangchen@cn.fujitsu.com> <20140702162408.GB4399@minantech.com>
In-Reply-To: <20140702162408.GB4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 12:24 AM, Gleb Natapov wrote:
> On Wed, Jul 02, 2014 at 05:00:35PM +0800, Tang Chen wrote:
>> Define guest phys_addr of apic access page.
>> ---
>>   arch/x86/include/asm/vmx.h | 2 +-
>>   arch/x86/kvm/svm.c         | 3 ++-
>>   arch/x86/kvm/vmx.c         | 7 ++++---
>>   3 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index 7004d21..c4672d1 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -422,7 +422,7 @@ enum vmcs_field {
>>   #define VMX_EPT_DIRTY_BIT				(1ull<<  9)
>>
>>   #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
>> -
>> +#define VMX_APIC_ACCESS_PAGE_ADDR		0xfee00000ull
>>
> It has nothing to do with VMX and there is already define for that: APIC_DEFAULT_PHYS_BASE

OK, followed.

