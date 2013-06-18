Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab3FRQXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:23:05 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47144 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:23:01 -0400
Date: Tue, 18 Jun 2013 18:22:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <liljegren.mats2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Full dynticks selftests 0.0.1
Message-ID: <20130618162256.GH17619@somewhere.redhat.com>
References: <20130612151915.GD5332@somewhere>
 <0000013f57a89d51-89f08a58-65d0-41f5-aaaa-b31d60c72a8e-000000@email.amazonses.com>
 <20130618151520.GP5146@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618151520.GP5146@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 08:15:20AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 18, 2013 at 02:20:35PM +0000, Christoph Lameter wrote:
> > On Wed, 12 Jun 2013, Frederic Weisbecker wrote:
> > 
> > > Here it is, a very basic test that runs a userspace loop for ten seconds and dumps a trace
> > > of the tick, scheduler, workqueue, and other kind of kernel noise.
> > 
> > Excellent. Ticks are finally off here. Also has useful instructions on how
> > to figure out if something was wrong. The number of >1 microsecond
> > disturbances went down from 110 per second to 2.
> 
> Very cool!
> 
> Frederic, is the git tree mentioned in your email permanent?  If so, I
> will add it to the documentation.

Yep, it should be permanent.

Thanks!
