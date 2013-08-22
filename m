Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3HVRow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:44:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35274 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3HVRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:44:51 -0400
Date: Thu, 22 Aug 2013 10:44:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 1/5] tracing: Add __tracepoint_string() to
 export string pointers
Message-ID: <20130822174447.GH29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130822163225.773134216@goodmis.org>
 <20130822163420.190373748@goodmis.org>
 <20130822170623.GF29406@linux.vnet.ibm.com>
 <20130822132753.0acb93a4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822132753.0acb93a4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082217-1542-0000-0000-000000BBFC3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:27:53PM -0400, Steven Rostedt wrote:
> On Thu, 22 Aug 2013 10:06:23 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Thu, Aug 22, 2013 at 12:32:26PM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> 
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Since you and I are both using the same commit, I wont be able to
> modify it to add you ack. :-/

I would rather not rebase, so happy without my ack added!  ;-)

							Thanx, Paul

