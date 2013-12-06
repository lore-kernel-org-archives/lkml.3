Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3LFPzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab3LFPzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:55:42 -0500
Date: Fri, 6 Dec 2013 16:56:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <htejun@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131206155619.GA7226@redhat.com>
References: <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com> <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com> <20131205143745.GA18488@redhat.com> <20131205143903.GA3231@htj.dyndns.org> <20131205153016.GA20705@redhat.com> <00000142c42d9708-c1154c9a-4265-45ee-971f-a6c8b5768ebf-000000@email.amazonses.com> <20131206145322.GB2674@redhat.com> <00000142c88e3976-f033b304-5a25-4cf3-854e-2ac02d209099-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142c88e3976-f033b304-5a25-4cf3-854e-2ac02d209099-000000@email.amazonses.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Christoph Lameter wrote:
>
> On Fri, 6 Dec 2013, Oleg Nesterov wrote:
>
> > This probably means that Tejun's "default attributes which are inherited
> > by all workqueues" suggestion was right.
>
> There are workqueues that are required to run on specific nodes /
> processors. Those cannot inherit these attributes and would need to be
> used regardless of the attributes if the kernel code demands it.

Yes, yes, Tejun actually said "inherited by all workqueues unless
they're explicitly overridden", I stripped his words too much.

Oleg.

