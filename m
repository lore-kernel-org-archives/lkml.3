Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3DKTPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:15:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48269 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3DKTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:15:47 -0400
Date: Thu, 11 Apr 2013 12:14:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>, Kevin Hilman <khilman@linaro.org>,
        Christoph Lameter <cl@linux.com>, arnd@arndb.de,
        Robin.Randhawa@arm.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
Message-ID: <20130411191442.GP29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <5166EF74.4030106@linux.intel.com>
 <20130411182727.GM29861@linux.vnet.ibm.com>
 <20130411184313.GH22229@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411184313.GH22229@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041119-5806-0000-0000-000020B15095
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 12:13:13AM +0530, Dipankar Sarma wrote:
> On Thu, Apr 11, 2013 at 11:27:27AM -0700, Paul E. McKenney wrote:
> > On Thu, Apr 11, 2013 at 10:14:28AM -0700, Arjan van de Ven wrote:
> > > >+2.	Many architectures will place dyntick-idle CPUs into deep sleep
> > > >+	states, which further degrades from-idle transition latencies.
> > > >+
> > > I think this part should just be deleted.
> > > On x86, the deeper idle states are even used with non-tickless system (the break even times are
> > > quite a bit less than even 1 msec).
> > > I can't imagine that ARM is worse on this, at which point the statement above is highly dubious
> > 
> > Interesting point, and I freely admit that I don't have full knowledge
> > of the energy-consumption characteristics of all the architectures that
> > Linux supports.  Adding a few of the ARM guys on CC for their take,
> > plus linux-rt-users.
> > 
> > If there are no objections, I will delete point 2 above as Arjan suggests.
> 
> What Arjan said will also be true for Linux on Power systems. I am not
> sure "many architectures" would be the right way to characterize it.

Very well, I count one non-objection to Arjan's suggestion.  ;-)

							Thanx, Paul

