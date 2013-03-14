Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3CNWRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:17:21 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:51828 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3CNWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
References: <20130226070247.GA14094@gmail.com>
	<CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
	<CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
	<CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
Date: Thu, 14 Mar 2013 15:17:19 -0700
X-Google-Sender-Auth: LjU9jUBrfrTvcz7olCXqR5zZbdc
Message-ID: <CA+55aFzDMwHyPxqxNKRz0Y3vFhZOqtHMvPbvNXAD6C+-_=UAhg@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 3:09 PM, Stephane Eranian <eranian@google.com> wrote:
>
> Could be related to suspend/resume. But were you running perf across
> that resume/suspend cycle?

No.

In most cases I was running a perf record before and after (but not
*while* suspending)

In at least one other crash, I didn't run perf before at all, so the
first time I used perf was after the resume.

So in no cases did I actually have any perf stuff active over the
suspend itself.

> Let's see if we can reproduce the problem on the same ChromeBook you
> have. Don't have one myself.

I don't imagine it should be about chromebook per se, because afaik
all of pmu suspend/resume is done by the kernel, no firmware involved.

So I'd assume it should happen with any IvyBridge.

            Linus
