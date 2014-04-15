Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaDOHk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:40:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:40:55 -0400
Date: Tue, 15 Apr 2014 09:40:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20140415074040.GH11182@twins.programming.kicks-ass.net>
References: <20140414151929.GA21470@redhat.com>
 <20140414151959.GA21995@redhat.com>
 <20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414150221.b62ccb9fb9056527c565872f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:02:21PM -0700, Andrew Morton wrote:
> Anyway, emails are cheap and nobody reads lkml so please just resend
> everything ;)

You're nobody right? ;-) At least the rumour went you actually read
lkml.
