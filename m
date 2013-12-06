Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab3LFOwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:52:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3LFOwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:52:49 -0500
Date: Fri, 6 Dec 2013 15:53:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <htejun@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131206145322.GB2674@redhat.com>
References: <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com> <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com> <20131205143745.GA18488@redhat.com> <20131205143903.GA3231@htj.dyndns.org> <20131205153016.GA20705@redhat.com> <00000142c42d9708-c1154c9a-4265-45ee-971f-a6c8b5768ebf-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142c42d9708-c1154c9a-4265-45ee-971f-a6c8b5768ebf-000000@email.amazonses.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Christoph Lameter wrote:
>
> On Thu, 5 Dec 2013, Oleg Nesterov wrote:
>
> > Perhaps, I simply do not know what the users want.
>
> We would like to control OS spawning of threads and restrict them to a
> limited set of cpus so that the other processors can do latency sensitive
> work without being impacted by creation of kernel threads etc.

This probably means that Tejun's "default attributes which are inherited
by all workqueues" suggestion was right.

Oleg.

