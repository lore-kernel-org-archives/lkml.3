Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaDOS3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaDOS3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:29:15 -0400
Date: Tue, 15 Apr 2014 20:28:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Marek Mahut <mmahut@redhat.com>
Subject: Re: [PATCH RESEND 04/11] signals: rename rm_from_queue_full() to
	flush_sigqueue_mask()
Message-ID: <20140415182838.GA12821@redhat.com>
References: <20140414151929.GA21470@redhat.com> <20140414151959.GA21995@redhat.com> <20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Andrew Morton wrote:
>
> On Mon, 14 Apr 2014 17:19:59 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > "rm_from_queue_full" looks ugly and misleading, especially now that
> > rm_from_queue() has gone away. Rename it to flush_sigqueue_mask(),
> > this matches flush_sigqueue() we already have.
> >
> > Also remove the obsolete comment which explains the difference with
> > rm_from_queue() we already killed.
> >
>
> Confused.  You sent 0..11 on March 24 and today you resent just 4, 5,
> 10 and 11.  If they're supposed to be replacement versions then please
> explain this!

No, no, this is another case when my emails go to nowhere :[

Marek, perhaps you can take a look ;)

> Anyway, emails are cheap and nobody reads lkml so please just resend
> everything ;)

Yes, will resend the whole series, thanks.

Oleg.

