Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDOHqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:46:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaDOHqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:46:13 -0400
Date: Tue, 15 Apr 2014 00:45:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
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
Message-Id: <20140415004554.296ef4f4.akpm@linux-foundation.org>
In-Reply-To: <20140415074040.GH11182@twins.programming.kicks-ass.net>
References: <20140414151929.GA21470@redhat.com>
	<20140414151959.GA21995@redhat.com>
	<20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
	<20140415074040.GH11182@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 09:40:40 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Apr 14, 2014 at 03:02:21PM -0700, Andrew Morton wrote:
> > Anyway, emails are cheap and nobody reads lkml so please just resend
> > everything ;)
> 
> You're nobody right? ;-) At least the rumour went you actually read
> lkml.

I scan them all to pick out neglected patches and interesting bug
reports, but my days of reading all the message bodies ended long
ago.
