Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaDHQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:56:08 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61165 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaDHQ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:56:05 -0400
Message-ID: <1396976162.4613.15.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 08 Apr 2014 18:56:02 +0200
In-Reply-To: <20140408155311.GP11096@twins.programming.kicks-ass.net>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	 <1396239636.5361.57.camel@marge.simpson.net>
	 <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
	 <1396290426.5261.80.camel@marge.simpson.net>
	 <CA+55aFwdosGtoh8=krpx9C-fT-H7OHsC0UVyXc8aNE7h=W1RxQ@mail.gmail.com>
	 <1396322880.5324.37.camel@marge.simpson.net>
	 <20140401095548.GB1299@gmail.com>
	 <1396512138.5404.32.camel@marge.simpson.net>
	 <20140408155311.GP11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 17:53 +0200, Peter Zijlstra wrote:

> OK; so as previously mentioned (Oct '13); I've entirely had it with
> skip_clock_update bugs, so I got angry and did the below.

Goody, kick butt take names ;-)

> Its not something I can merge, not least because it uses trace_printk(),
> but it should be usable to 1) demonstate the above actually helps and 2)
> make damn sure we got it right this time :-)

That would be nice, little cycle savers like this aren't supposed to
have nasty corner cases that can clean your clock (pun intended).

> I've not really stared at the output much yet; but when you select
> function_graph tracer; we get lovely things like:

I'll plug it into my quilt pile.

-Mike


