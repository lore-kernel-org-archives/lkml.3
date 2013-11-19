Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3KSXOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:14:19 -0500
Received: from ozlabs.org ([203.10.76.45]:41580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab3KSXOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:14:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [GIT PULL] core kernel update
In-Reply-To: <20131119190904.GA22076@gmail.com>
References: <20131119154253.GA12219@gmail.com> <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com> <20131119190904.GA22076@gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Nov 2013 09:35:10 +1030
Message-ID: <8738msdmc9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:
> [*] Plus perhaps allow offstack to be configurable arbitrarily if 
>     debugging is enabled [DEBUG_PER_CPU_MAP=y], to allow easy
>     experiments/measurements?

Yes, it was good for i386 testing.

But now it seems that DEBUG_KERNEL is on for every distribution
(AFAICT), it's no longer an obscure option.  I'm happy to kill it.

Cheers,
Rusty.
