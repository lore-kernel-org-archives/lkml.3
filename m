Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaB0My1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:54:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaB0My0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:54:26 -0500
Message-ID: <530F3579.8030903@redhat.com>
Date: Thu, 27 Feb 2014 13:54:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, mtosatti@redhat.com, gleb@kernel.org,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH v2 0/2] KVM: x86: more xsave and mpx improvements
References: <1393433681-22888-1-git-send-email-pbonzini@redhat.com> <530F1F55.1020209@siemens.com>
In-Reply-To: <530F1F55.1020209@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/02/2014 12:19, Jan Kiszka ha scritto:
> On 2014-02-26 17:54, Paolo Bonzini wrote:
>> Here are the patches I mentioned while reviewing Liu Jinsong's MPX
>> series.
>>
>> Patch 1 is a further cleanup of xcr0 handling, and patch 2 introduces
>> nested virtualization support for MPX.
>>
>> Please review.
>>
>> Thanks,
>>
>> Paolo
>>
>> Paolo Bonzini (2):
>>   KVM: x86: introduce kvm_supported_xcr0()
>>   KVM: x86: Add nested virtualization support for MPX
>>
>>  arch/x86/kvm/cpuid.c | 27 ++++++++++++++++-----------
>>  arch/x86/kvm/vmx.c   | 17 +++++++++++++++++
>>  arch/x86/kvm/x86.c   |  4 +---
>>  arch/x86/kvm/x86.h   |  2 ++
>>  4 files changed, 36 insertions(+), 14 deletions(-)
>>
>
> Is this round different from the other v2?

No, they're the same.

Paolo

