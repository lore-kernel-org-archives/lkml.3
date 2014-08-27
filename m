Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbaH0Uo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:44:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964892AbaH0Uo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:44:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140827185138.GA12487@redhat.com>
References: <20140827185138.GA12487@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 0/4] x86, fpu: copy_process's FPU paths cleanups
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Aug 2014 13:43:14 -0700
To: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: Bean Anderson <bean@azulsystems.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <acea7803-1ed3-437e-9f4c-df8dd56feef8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, this is unacceptable.

Last week was Kernel Summit and that was right on the heels of a merge window.  We are backlogged like crazy and being rude doesn't help one iota.

On August 27, 2014 11:51:38 AM PDT, Oleg Nesterov <oleg@redhat.com> wrote:
>Hello,
>
>Who can review this? And where should I send FPU changes?
>
>And it seems that nobody cares about 2 fixes I sent before.
>Linus, I understand that you won't take them into v3.17, but
>perhaps you can ack/nack them explicitly? It seems that nobody
>can do this.
>
>Oleg.
>
> arch/x86/include/asm/fpu-internal.h |    2 +-
> arch/x86/kernel/process.c           |   16 +++++++++-------
> arch/x86/kernel/process_32.c        |    2 --
> arch/x86/kernel/process_64.c        |    1 -
> 4 files changed, 10 insertions(+), 11 deletions(-)

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
