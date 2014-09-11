Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaIKKY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:24:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38666 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaIKKYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:24:23 -0400
Message-ID: <5411784D.3010405@arm.com>
Date: Thu, 11 Sep 2014 11:24:13 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "cornelia.huck@de.ibm.com" <cornelia.huck@de.ibm.com>,
        "xiantao.zhang@intel.com" <xiantao.zhang@intel.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH] KVM: EVENTFD: remove inclusion of irq.h
References: <1409560568-6911-1-git-send-email-eric.auger@linaro.org> <54044647.4030605@redhat.com> <20140911030932.GA2784@lvm> <54114B21.1080102@redhat.com>
In-Reply-To: <54114B21.1080102@redhat.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 11 Sep 2014 10:24:14.0500 (UTC) FILETIME=[8914A640:01CFCDAA]
X-MC-Unique: 114091111242003501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/14 08:11, Paolo Bonzini wrote:
> Il 11/09/2014 05:09, Christoffer Dall ha scritto:
>> On Mon, Sep 01, 2014 at 12:11:19PM +0200, Paolo Bonzini wrote:
>>> Il 01/09/2014 10:36, Eric Auger ha scritto:
>>>> No more needed. irq.h would be void on ARM.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>>
>>>> ---
>>>>
>>>> I don't think irq.h is needed anymore since Paul Mackerras' work. However
>>>> I did not compile for all architectures.
>>>> ---
>>>>  virt/kvm/eventfd.c | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>>> index 3c5981c..0c712a7 100644
>>>> --- a/virt/kvm/eventfd.c
>>>> +++ b/virt/kvm/eventfd.c
>>>> @@ -36,7 +36,6 @@
>>>>  #include <linux/seqlock.h>
>>>>  #include <trace/events/kvm.h>
>>>>  
>>>> -#include "irq.h"
>>>>  #include "iodev.h"
>>>>  
>>>>  #ifdef CONFIG_HAVE_KVM_IRQFD
>>>>
>>>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>
>>> Christoffer, please include this via the ARM tree, together with ARM
>>> irqfd support.  Thanks,
>>>
>> Marc is dealing with the tree this week and the next so he can apply it
>> to kvmarm/queue.  Do you want it to wait and go with the irqfd patch
>> (which has dependencies not yet resolved) or should we just queue it?
> 
> As you prefer.

Added to kvmarm/queue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

