Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaDOILO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:11:14 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35286 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750911AbaDOILL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:11:11 -0400
Message-ID: <534CE999.10209@arm.com>
Date: Tue, 15 Apr 2014 09:11:05 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jungseok Lee <jays.lee@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
Subject: Re: [PATCH 2/8] arm/arm64: KVM: Fix line length exceeding 80 characters
References: <000001cf57b4$d3450780$79cf1680$@samsung.com> <534C0A89.4090907@arm.com> <001601cf5843$07c38160$174a8420$@samsung.com>
In-Reply-To: <001601cf5843$07c38160$174a8420$@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/14 01:38, Jungseok Lee wrote:
> On Tuesday, April 15, 2014 1:19 AM, Marc Zyngier wrote:
>> On 14/04/14 08:40, Jungseok Lee wrote:
>>> This patch deals with checkpatch complaint as fixing line length
>>> exceeding 80 characters.
>>>
>>> WARNING: line over 80 characters
>>>
>>> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
>>> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
>>> ---
>>>  arch/arm/kvm/mmu.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c index
>>> 80bb1e6..e0d4f24 100644
>>> --- a/arch/arm/kvm/mmu.c
>>> +++ b/arch/arm/kvm/mmu.c
>>> @@ -563,8 +563,8 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>>>  	kvm->arch.pgd = NULL;
>>>  }
>>>
>>> -static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>> -			     phys_addr_t addr)
>>> +static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache
>>> +			     *cache, phys_addr_t addr)
>>
>> Please don't. This makes the code unreadable (and no, I don't care about checkpatch ;-).
> 
> Okay. I will drop this patch from the next version.
> 
> It would be good to change stage2_set_pmd_huge function for readability
> if you don't care about checkpatch.

We usually don't change that kind of thing just for the sake of changing
it. It feels like fairly pointless churn. *IF* someone happens to rework
that code, then they're welcome to fix it.

	M.
-- 
Jazz is not dead. It just smells funny...
