Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaH1BR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:17:58 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63109 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbaH1BRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140827185138.GA12487@redhat.com>
References: <20140827185138.GA12487@redhat.com>
Date: Wed, 27 Aug 2014 18:17:55 -0700
X-Google-Sender-Auth: U3t0z2EbbzcSymT6r0xCjl6ov2U
Message-ID: <CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Who can review this? And where should I send FPU changes?

FWIW, I have nothing against this series (or, indeed, the last series
with the exception of 2/5 that got replaced by just the preemption
disable).

Although with the whole i387 state I always hope somebody else checks
it too, and it's obviously not 3.17 material any more (possibly with
the exception of the afore-mentioned preemption patch, although even
that might be better off as 3.18 + stable)

            Linus
