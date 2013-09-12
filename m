Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3ILUi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:38:26 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:33595 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3ILUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130912203358.GE32644@gmail.com>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
	<20130912203358.GE32644@gmail.com>
Date: Thu, 12 Sep 2013 13:38:18 -0700
X-Google-Sender-Auth: eolNQu6VnKfM5aOmVphigdhgyvQ
Message-ID: <CA+55aFwwO3+-EndiLxO+2cmpYGvt_R7vbOBbFvELsmDcWDGdAQ@mail.gmail.com>
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

On Thu, Sep 12, 2013 at 1:33 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Hm, just to make sure, are you running a (very fresh) kernel that has this
> fix included:
>
> d008d5258e9c perf: Fix up MMAP2 buffer space reservation

I've rebooted about five times since that report, so I'm not sure..

[ Short time passes ]

Hmm. That "reproducible" error is no longer reproducible for me on
current git (68f0d9d92e54). So if you fixed something recently, it's
possible I was running a pre-perf-pull kernel and an after-perf-pull
"perf" binary.

              Linus
