Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab3JNTIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:08:31 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:59508 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266Ab3JNTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:08:30 -0400
Date: Mon, 14 Oct 2013 19:02:29 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, David Miller <davem@davemloft.net>,
        tj@kernel.org, akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
In-Reply-To: <20131014103258.GY3081@twins.programming.kicks-ass.net>
Message-ID: <00000141b8591950-3f399b8b-fdc7-41a0-b84c-bb632e8adba7-000000@email.amazonses.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com> <20131011.140814.422793173894221852.davem@davemloft.net> <20131012165120.GA15116@gmail.com> <20131014103258.GY3081@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.14-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, Peter Zijlstra wrote:

> > Most kernel developers tend to use 'git send-email' to send patches to
> > lkml, and that method is working pretty reliably.
>
> I always use quilt mail, it typically adds a reference to the 0/0 email
> and ensures the time of each msg is one second ahead of the previous one
> to ensure order is correct.

Yes that I also what I expected to happen and what always happened in the
past.

> I've no idea how Christoph managed to wreck this, but normally quilt
> mail DTRT (as opposed to git send-email which used to default to
> endlessly deep threads -- got fixed in 1.6 or 1.7 or thereabouts).

Well this is going through Amazon cloud email which may be wrecking
things. Had a number of issues already with messages being delayed etc. I
can try to revert to my home setup and see if that fixes things.

