Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaDNWCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:02:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaDNWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:02:24 -0400
Date: Mon, 14 Apr 2014 15:02:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 04/11] signals: rename rm_from_queue_full() to
 flush_sigqueue_mask()
Message-Id: <20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
In-Reply-To: <20140414151959.GA21995@redhat.com>
References: <20140414151929.GA21470@redhat.com>
	<20140414151959.GA21995@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 17:19:59 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> "rm_from_queue_full" looks ugly and misleading, especially now that
> rm_from_queue() has gone away. Rename it to flush_sigqueue_mask(),
> this matches flush_sigqueue() we already have.
> 
> Also remove the obsolete comment which explains the difference with
> rm_from_queue() we already killed.
> 

Confused.  You sent 0..11 on March 24 and today you resent just 4, 5,
10 and 11.  If they're supposed to be replacement versions then please
explain this!

Anyway, emails are cheap and nobody reads lkml so please just resend
everything ;)
