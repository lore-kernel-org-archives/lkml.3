Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3HEOdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:33:04 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43014 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3HEOdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:33:02 -0400
Date: Mon, 5 Aug 2013 16:32:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130805143257.GA32639@gmail.com>
References: <1375712355.22073.45.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375712355.22073.45.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Linus,
> 
> Oleg Nesterov has been working hard in closing all the holes that can 
> lead to race conditions between deleting an event and accessing an event 
> debugfs file. This included a fix to the debugfs system (acked by Greg 
> Kroah-Hartman). We think that all the holes have been patched and 
> hopefully we don't find more. I haven't marked all of them for stable 
> because I need to examine them more to figure out how far back some of 
> the changes need to go.

Sigh, that's quite some churn still - unless these bugs were introduced in 
the v3.11 merge window (i.e. are genuine _regressions_), shouldn't such 
invasive fixes really go into v3.12 instead?

I see that some of the fixes here fix issues that your earlier post-rc1 
rounds of non-regression fixes introduced to begin with. That's really not 
a good pattern either IMO.

Thanks,

	Ingo
