Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaKTWHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:07:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:53410 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbaKTWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:07:39 -0500
Date: Thu, 20 Nov 2014 23:07:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andy Lutomirski <luto@amacapital.net>, Dave Jones <davej@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86, syscall: Fix _TIF_NOHZ handling in
 syscall_trace_enter_phase1
In-Reply-To: <CA+55aFz-UKma1UmspBJExS5AH8sA=nTARR-G6JJeaMxN+K-WAw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411202306450.3950@nanos>
References: <546D0530.8040800@mit.edu> <a6cd3b60a3f53afb6e1c8081b0ec30ff19003dd7.1416434075.git.luto@amacapital.net> <alpine.DEB.2.11.1411192311560.3909@nanos> <CA+55aFz-UKma1UmspBJExS5AH8sA=nTARR-G6JJeaMxN+K-WAw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Linus Torvalds wrote:
> On Wed, Nov 19, 2014 at 2:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Right, while it is wrong it does not explain the wreckage on 3.17,
> > which does not have that code.
> 
> Thomas, I'm currently going off the assumption that I'll see this from
> the x86 trees, and I can ignore the patch. It doesn't seem like this
> is a particularly pressing bug.
> 
> If it's *not* going to show up as a pull request, holler, and I'll
> just apply it.

I'll send out a updated pul request for the one Ingo sent earlier
today in a second.

Thanks,

	tglx
