Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaF3JOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:14:33 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12840 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751716AbaF3JOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:14:31 -0400
Message-ID: <53B12A6A.5050105@arm.com>
Date: Mon, 30 Jun 2014 10:14:18 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: Will Deacon <Will.Deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2 v2] ARM: KVM: user_mem_abort: support stage 2 MMIO
 page mapping
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org> <1395785294-2545-2-git-send-email-kim.phillips@linaro.org> <20140506180448.GH3066@lvm> <87bnvaotei.fsf@approximate.cambridge.arm.com> <20140507145557.GJ3066@lvm> <20140624102327.GA9121@arm.com> <53A9556D.3000003@arm.com> <20140625194551.a6443252bf913023159d25fd@freescale.com> <20140626084625.GA376@arm.com> <20140630090843.GB9233@cbox>
In-Reply-To: <20140630090843.GB9233@cbox>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/14 10:08, Christoffer Dall wrote:
> On Thu, Jun 26, 2014 at 09:46:26AM +0100, Will Deacon wrote:
>> On Thu, Jun 26, 2014 at 01:45:51AM +0100, Kim Phillips wrote:
>>> From: Kim Phillips <kim.phillips@linaro.org>
>>>
>>> A userspace process can map device MMIO memory via VFIO or /dev/mem,
>>> e.g., for platform device passthrough support in QEMU.
>>>
>>> During early development, we found the PAGE_S2 memory type being used
>>> for MMIO mappings.  This patch corrects that by using the more strongly
>>> ordered memory type for device MMIO mappings: PAGE_S2_DEVICE.
>>>
>>> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
>>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>> Hi, here's a v2, upon request:
>>>
>>> - rebased onto today's mainline ToT
>>> - mmu.o-build tested only (ToT build doesn't complete)
>>> - made commit text less terse
>>> - added Christoffer's ack
>>
>> Thanks for reposting this so quickly!
>>
>>   Acked-by: Will Deacon <will.deacon@arm.com>
>>
> Thanks,
> 
> Marc, will you apply this one to kvmarm/queue [and kvmarm/next]?

Yup, adding it.

	M.
-- 
Jazz is not dead. It just smells funny...
