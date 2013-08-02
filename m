Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3HBQcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:32:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45538 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3HBQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:32:45 -0400
Date: Fri, 2 Aug 2013 09:32:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4 v2] [GIT PULL][RCU][3.12] tracing/rcu: Export strings
 to userspace
Message-ID: <20130802163202.GG3836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130802023933.677590002@goodmis.org>
 <20130802155111.GA3836@linux.vnet.ibm.com>
 <1375460559.22073.4.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375460559.22073.4.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080216-2398-0000-0000-00000107FFA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:22:39PM -0400, Steven Rostedt wrote:
> On Fri, 2013-08-02 at 08:51 -0700, Paul E. McKenney wrote:
> 
> > I have merged these into v3.11-rc3 in my local tree like this:
> > 
> > # git log --pretty=oneline v3.11-rc3..
> > a6f8eb9e4c18ba0e9a2ed4d2dec888440da12549 Merge branch 'ftrace/rcu-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into rostedt.2013.08.02a
> > f7f7bac9cb1c50783f15937a11743655a5756a36 rcu: Have the RCU tracepoints use the tracepoint_string infrastructure
> > a41bfeb2f8ed59410be7ca0f8fbc6138a758b746 rcu: Simplify RCU_STATE_INITIALIZER() macro
> > e66c33d579ea566d10e8c8695a7168aae3e02992 rcu: Add const annotation to char * for RCU tracepoints and functions
> > 102c9323c35a83789ad5ebd3c45fa8fb389add88 tracing: Add __tracepoint_string() to export string pointers
> > 
> > Amazingly enough, there is only one trivial conflict with the current
> > 3.12 RCU commits, so my plan is to treat these commits as a separate
> > topic branch for RCU.
> 
> Sounds good. Thanks!

Ah -- unlike my normal approach, I will -not- be rebasing this particular
topic branch, so we should be able to both send them upstream without
any problems.

Famous last words.  ;-)

							Thanx, Paul

