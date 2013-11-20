Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3KTLuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:50:24 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62830 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KTLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:50:21 -0500
Date: Wed, 20 Nov 2013 12:50:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [GIT PULL] core kernel update
Message-ID: <20131120115016.GA6573@gmail.com>
References: <20131119154253.GA12219@gmail.com>
 <CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
 <20131119190904.GA22076@gmail.com>
 <8738msdmc9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738msdmc9.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> > [*] Plus perhaps allow offstack to be configurable arbitrarily if 
> >     debugging is enabled [DEBUG_PER_CPU_MAP=y], to allow easy
> >     experiments/measurements?
> 
> Yes, it was good for i386 testing.
> 
> But now it seems that DEBUG_KERNEL is on for every distribution 
> (AFAICT), it's no longer an obscure option.  I'm happy to kill it.

It would depend on DEBUG_PER_CPU_MAP=y, not DEBUG_KERNEL=y.

Thanks,

	Ingo
