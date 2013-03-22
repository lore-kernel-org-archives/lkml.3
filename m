Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422644Ab3CVQaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:30:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46076 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160996Ab3CVQaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:30:07 -0400
Date: Fri, 22 Mar 2013 09:28:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130322162820.GN3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
 <20130321171518.GW3637@linux.vnet.ibm.com>
 <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
 <20130321185821.GF3637@linux.vnet.ibm.com>
 <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
 <20130321205054.GI3637@linux.vnet.ibm.com>
 <0000013d9289cebc-e6380265-3a74-4343-b851-765f785a3754-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013d9289cebc-e6380265-3a74-4343-b851-765f785a3754-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032216-4834-0000-0000-000004FBCCB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:38:58PM +0000, Christoph Lameter wrote:
> On Thu, 21 Mar 2013, Paul E. McKenney wrote:
> 
> > So, how long of busy periods are you contemplating for your SCHED_FIFO
> > threads?  Is it possible to tune/adjust the offending per-CPU ktheads
> > to wake up less frequently than that time?
> 
> Test programs right now run 10 seconds. 30 seconds would definitely be
> enough for the worst case.

OK, that might be doable for some workloads.  What happens when you
try tuning the 2-second wakeup interval to (say) 45 seconds?

							Thanx, Paul

