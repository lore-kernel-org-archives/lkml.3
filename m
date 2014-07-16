Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbaGPQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:13:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbaGPQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:13:38 -0400
Message-ID: <53C6A4A3.1040702@zytor.com>
Date: Wed, 16 Jul 2014 09:13:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@amacapital.net>
CC: Daniel Borkmann <dborkman@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com> <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com> <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com> <53C6A236.7040904@zytor.com> <53C6A362.7090709@redhat.com>
In-Reply-To: <53C6A362.7090709@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:08 AM, Paolo Bonzini wrote:
> Il 16/07/2014 18:03, H. Peter Anvin ha scritto:
>> I suggested emulating RDRAND *but not set the CPUID bit*.  We already
>> developed a protocol in KVM/Qemu to enumerate emulated features (created
>> for MOVBE as I recall), specifically to service the semantic "feature X
>> will work but will be substantially slower than normal."
> 
> But those will set the CPUID bit.  There is currently no way for KVM
> guests to know if a CPUID bit is real or emulated.
> 

OK, so there wasn't any protocol implemented in the end.  I sit corrected.

	-hpa


