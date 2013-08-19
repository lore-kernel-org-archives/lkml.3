Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3HSAeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 20:34:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47872 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3HSAeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:34:05 -0400
Date: Sun, 18 Aug 2013 17:33:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH tip/core/rcu 06/11] rcu: Switch to exedited grace periods
 for suspend as well as hibernation
Message-ID: <20130819003356.GT29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789876-27594-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818032009.GN28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130818032009.GN28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081900-5518-0000-0000-0000114CF1FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 08:20:09PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:37:51PM -0700, Paul E. McKenney wrote:
> > From: Bjørn Mork <bjorn@mork.no>
> > 
> > Commit 587ff2cf ("rcu: Expedite grace periods during suspend/resume")
> > enabled expedited grace periods for hibernation, but not for suspend.
> > The same issue applies to both cases, so this commit simply applies the
> > same logic by adding additional cases to the switch statement.
> > 
> > Note that this commit also switches from PM_POST_RESTORE to the
> > combination of PM_POST_HIBERNATION and PM_POST_SUSPEND.  A separate
> > patch from Borislav Petkov corrects the documentation to indicate that
> > this is necessary.
> > 
> > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Please squash this together with the other two relevant patches in this
> series.

Done!  (Of course, retaining both Borislav's and Bjørn's Signed-off-bys.)

							Thanx, Paul

