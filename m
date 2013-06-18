Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3FRPPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:15:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34011 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab3FRPPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:15:53 -0400
Date: Tue, 18 Jun 2013 08:15:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Full dynticks selftests 0.0.1
Message-ID: <20130618151520.GP5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130612151915.GD5332@somewhere>
 <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061815-7182-0000-0000-00000761B50D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:20:35PM +0000, Christoph Lameter wrote:
> On Wed, 12 Jun 2013, Frederic Weisbecker wrote:
> 
> > Here it is, a very basic test that runs a userspace loop for ten seconds and dumps a trace
> > of the tick, scheduler, workqueue, and other kind of kernel noise.
> 
> Excellent. Ticks are finally off here. Also has useful instructions on how
> to figure out if something was wrong. The number of >1 microsecond
> disturbances went down from 110 per second to 2.

Very cool!

Frederic, is the git tree mentioned in your email permanent?  If so, I
will add it to the documentation.

							Thanx, Paul

