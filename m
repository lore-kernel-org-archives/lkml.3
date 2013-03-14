Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3CNWTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:19:16 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63320 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3CNWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzDMwHyPxqxNKRz0Y3vFhZOqtHMvPbvNXAD6C+-_=UAhg@mail.gmail.com>
References: <20130226070247.GA14094@gmail.com>
	<CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
	<CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
	<CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
	<CA+55aFzDMwHyPxqxNKRz0Y3vFhZOqtHMvPbvNXAD6C+-_=UAhg@mail.gmail.com>
Date: Thu, 14 Mar 2013 23:19:14 +0100
Message-ID: <CABPqkBTTY7RBSXJw4kqdd0c07Ykz-Wy8TFUQ+hzBSn=5v2yz2w@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Stephane Eranian <eranian@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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

On Thu, Mar 14, 2013 at 11:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 14, 2013 at 3:09 PM, Stephane Eranian <eranian@google.com> wrote:
>>
>> Could be related to suspend/resume. But were you running perf across
>> that resume/suspend cycle?
>
> No.
>
> In most cases I was running a perf record before and after (but not
> *while* suspending)
>
> In at least one other crash, I didn't run perf before at all, so the
> first time I used perf was after the resume.
>
> So in no cases did I actually have any perf stuff active over the
> suspend itself.
>
Ok, simpler test case then.

>> Let's see if we can reproduce the problem on the same ChromeBook you
>> have. Don't have one myself.
>
> I don't imagine it should be about chromebook per se, because afaik
> all of pmu suspend/resume is done by the kernel, no firmware involved.
>
> So I'd assume it should happen with any IvyBridge.
>
Will try on a desktop IvyBridge too.
