Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3IMK4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:56:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44821 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3IMK4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:56:53 -0400
Date: Fri, 13 Sep 2013 12:56:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913105637.GM31370@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912141913.2ffc7077@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:

> > The good news is I can reproduce that very quickly.
> > (Apply http://paste.fedoraproject.org/38721/37890755 on top of trinity.git,
> >  and run ./trinity -l off -q -C32 -c inotify_init1 -c perf_event_open -c newlstat)

" The paste you are looking for does not exist "

And that line on its own doesn't seem to do much.. its been running for
minutes now.

Or does 'quickly' mean something else?
