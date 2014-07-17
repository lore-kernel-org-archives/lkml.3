Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaGQSs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:48:58 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:49452 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaGQSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:48:56 -0400
X-Greylist: delayed 3139 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2014 14:48:56 EDT
MIME-Version: 1.0
In-Reply-To: <4454941956362c58e676610d3bf489f58c689d46.1405620944.git.luto@amacapital.net>
References: <cover.1405620944.git.luto@amacapital.net>
	<4454941956362c58e676610d3bf489f58c689d46.1405620944.git.luto@amacapital.net>
Date: Thu, 17 Jul 2014 11:48:55 -0700
X-Google-Sender-Auth: A-_WqoZsEYSk7U92OaTcgU9HnQ8
Message-ID: <CAGXu5jJcwh9WYTOQQ1hznSm-UpSQN+OLUWWH4aNR3UD_snWu3A@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> It's considerably better than any of the alternatives on KVM.
>
> Rather than reinventing all of the cpu feature query code, this fixes
> native_cpuid to work in PIC objects.
>
> I haven't combined it with boot/cpuflags.c's cpuid implementation:
> including asm/processor.h from boot/cpuflags.c results in a flood of
> unrelated errors, and fixing it might be messy.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

This will be very nice to have under kvm!

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
