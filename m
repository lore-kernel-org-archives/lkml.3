Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaH0HH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:07:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39885 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaH0HH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:07:56 -0400
Message-ID: <53FD83B4.1030507@zytor.com>
Date: Wed, 27 Aug 2014 00:07:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@amacapital.net>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Gleb Natapov <gleb@kernel.org>, Andrew Honig <ahonig@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alok Kataria <akataria@vmware.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: GET_RNG_SEED hypercall ABI? (Re: [PATCH v5 0/5] random,x86,kvm:
 Rework arch RNG seeds and get some from kvm)
References: <CALCETrV5U61C-gkikZtddd5RtZWFVRpkjVk69B+ymvy=xauLaQ@mail.gmail.com> <53FD81F5.6030701@redhat.com>
In-Reply-To: <53FD81F5.6030701@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 12:00 AM, Paolo Bonzini wrote:
> Il 27/08/2014 01:58, Andy Lutomirski ha scritto:
>> hpa pointed out that the ABI that I chose (an MSR from the KVM range
>> and a KVM cpuid bit) is unnecessarily KVM-specific.  It would be nice
>> to allocate an MSR that everyone involved can agree on and, rather
>> than relying on a cpuid bit, just have the guest probe for the MSR.
>>
>> This leads to a few questions:
>>
>> 1. How do we allocate an MSR?  (For background, this would be an MSR
>> that either returns 64 bits of best-effort cryptographically secure
>> random data or fails with #GP.)
> 
> Ask Intel? :)

I'm going to poke around internally.  Intel might as a matter of policy
be reluctant to assign an MSR index specifically for software use, but
I'll try to find out.

	-hpa

