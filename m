Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3HENfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:35:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab3HENfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:35:12 -0400
Date: Mon, 5 Aug 2013 15:29:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc4
Message-ID: <20130805132948.GA14942@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Felipe Contreras wrote:
>
> I found a regression while running all v3.11-rcX kernels; Starcract II
> through wine crashes.

Thanks... just to clarify, Starcract crashes, wine or kernel?

> The culprit is fab840f (ptrace: PTRACE_DETACH
> should do flush_ptrace_hw_breakpoint(child)), I revert that commit and
> there's no crash.

I never used wine, but I am puzzled anyway. This patch really looks
like a simple and minor bugfix.

Could you please run wine under strace

	strace -f -e ptrace -o LOG wine ...

and show the result?

Oleg.

