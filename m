Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaIKHNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:13:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaIKHNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:13:19 -0400
Message-ID: <54114B21.1080102@redhat.com>
Date: Thu, 11 Sep 2014 09:11:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, gleb@kernel.org,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        xiantao.zhang@intel.com, agraf@suse.de, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] KVM: EVENTFD: remove inclusion of irq.h
References: <1409560568-6911-1-git-send-email-eric.auger@linaro.org> <54044647.4030605@redhat.com> <20140911030932.GA2784@lvm>
In-Reply-To: <20140911030932.GA2784@lvm>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 05:09, Christoffer Dall ha scritto:
> On Mon, Sep 01, 2014 at 12:11:19PM +0200, Paolo Bonzini wrote:
>> Il 01/09/2014 10:36, Eric Auger ha scritto:
>>> No more needed. irq.h would be void on ARM.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> ---
>>>
>>> I don't think irq.h is needed anymore since Paul Mackerras' work. However
>>> I did not compile for all architectures.
>>> ---
>>>  virt/kvm/eventfd.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>> index 3c5981c..0c712a7 100644
>>> --- a/virt/kvm/eventfd.c
>>> +++ b/virt/kvm/eventfd.c
>>> @@ -36,7 +36,6 @@
>>>  #include <linux/seqlock.h>
>>>  #include <trace/events/kvm.h>
>>>  
>>> -#include "irq.h"
>>>  #include "iodev.h"
>>>  
>>>  #ifdef CONFIG_HAVE_KVM_IRQFD
>>>
>>
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Christoffer, please include this via the ARM tree, together with ARM
>> irqfd support.  Thanks,
>>
> Marc is dealing with the tree this week and the next so he can apply it
> to kvmarm/queue.  Do you want it to wait and go with the irqfd patch
> (which has dependencies not yet resolved) or should we just queue it?

As you prefer.

Paolo
