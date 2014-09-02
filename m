Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaIBFEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 01:04:04 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63480 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaIBFEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 01:04:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140827185138.GA12487@redhat.com>
References: <20140827185138.GA12487@redhat.com>
Date: Mon, 1 Sep 2014 22:04:00 -0700
Message-ID: <CALmL7E8kjWRvPk-jVzXBLW51qbsWnt7tgrC8Gcm6unYA5m3R7Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
From: Suresh Siddha <sbsiddha@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hello,
>
> Who can review this? And where should I send FPU changes?
>
> And it seems that nobody cares about 2 fixes I sent before.
> Linus, I understand that you won't take them into v3.17, but
> perhaps you can ack/nack them explicitly? It seems that nobody
> can do this.
>
> Oleg.
>
>  arch/x86/include/asm/fpu-internal.h |    2 +-
>  arch/x86/kernel/process.c           |   16 +++++++++-------
>  arch/x86/kernel/process_32.c        |    2 --
>  arch/x86/kernel/process_64.c        |    1 -
>  4 files changed, 10 insertions(+), 11 deletions(-)

These 4 patches also look good to me.

Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
