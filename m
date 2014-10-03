Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaJCUPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:15:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaJCUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:15:42 -0400
Date: Fri, 3 Oct 2014 22:15:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Erik Bosman <ebn310@few.vu.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Message-ID: <20141003201537.GN10583@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <20141003174141.GR2342@redhat.com>
 <CALCETrWP7QSb4dFh_phUK+7P-XookgL8UXgvHi-e4icukUF2Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWP7QSb4dFh_phUK+7P-XookgL8UXgvHi-e4icukUF2Og@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 10:59:15AM -0700, Andy Lutomirski wrote:
> RDPMC is controlled by CR4.PCE, whereas RDTSC is controlled by
> CR4.TSD,

This is my understanding too, they're separate things.
