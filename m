Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3ILUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:52:31 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:39315 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3ILUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130912204910.GB3262@gmail.com>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
	<20130912203358.GE32644@gmail.com>
	<CA+55aFwwO3+-EndiLxO+2cmpYGvt_R7vbOBbFvELsmDcWDGdAQ@mail.gmail.com>
	<20130912204910.GB3262@gmail.com>
Date: Thu, 12 Sep 2013 13:52:29 -0700
X-Google-Sender-Auth: FfJbMLYE50aQQoeURyzN-l8p1QY
Message-ID: <CA+55aFyJCJJmwgf0kKFqA-aP-Gq6Y-1RhTsf2NokRcixtbbk3A@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 1:49 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> I think the window of breakage is relatively small (you managed to hit
> it), but should we add a quirk for this?

Was the breakage entirely inside the merge window? ie no released kernels?

If so, just ignore it.

             Linus
