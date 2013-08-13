Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3HMCjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab3HMCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:39:43 -0400
Date: Mon, 12 Aug 2013 22:39:22 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] tracing: final fixes for events and some
Message-ID: <20130813023922.GA1042@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1375712355.22073.45.camel@gandalf.local.home>
 <20130805143257.GA32639@gmail.com>
 <1375714329.22073.63.camel@gandalf.local.home>
 <20130812181325.GA19405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812181325.GA19405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 08:13:25PM +0200, Ingo Molnar wrote:
 > > > I see that some of the fixes here fix issues that your earlier 
 > > > post-rc1 rounds of non-regression fixes introduced to begin with. 
 > > > That's really not a good pattern either IMO.
 > > 
 > > Not really. The earlier fixes closed some of the holes but were not good 
 > > enough. They didn't cause more regressions, but the method use to fix 
 > > the regressions it was trying to solve wasn't going to work when we saw 
 > > the extent of the regressions that had to be fixed. Oleg came up with a 
 > > better method, which meant that we had to undo the original fix, for a 
 > > even better fix.
 > 
 > My point is that _neither_ should have gone in after the merge window. 
 > -rc1 and onwards are to fix regressions caused in the merge window, full 
 > stop. Yet there was a steady stream of tracing changes in kernel/ that at 
 > best fixed ancient bugs that are only root triggerable and which nobody 
 > actually triggered all that much. Followed by fixes to the fixes.

I'm not sure why I got cc'd on this, but for my part, the perf/tracing related bugs
I've found recently may have been there for ages, but they were triggerable
as non-root users.

	Dave

