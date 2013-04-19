Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab3DSVr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:47:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56321 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab3DSVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:47:25 -0400
Date: Fri, 19 Apr 2013 14:47:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
Message-ID: <20130419214709.GO3479@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <877gjyxmiq.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gjyxmiq.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041921-5406-0000-0000-000007ACAEDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 02:01:49PM -0700, Kevin Hilman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > +KNOWN ISSUES
> 
> [...]
> 
> > +o	Unless all CPUs are idle, at least one CPU must keep the
> > +	scheduling-clock interrupt going in order to support accurate
> > +	timekeeping.
> 
> At least with the implementation I'm using (Frederic's 3.9-nohz1
> branch), at least one CPU is forced to stay out of dyntick-idle
> *always*, even if all CPUs are idle.
> 
> IMO, this is important to list as a known issue since this will have
> its own power implications when the system is mostly idle.

Good point!  I added the following at the end of the known issues:

o	If there are adaptive-ticks CPUs, there will be at least one
	CPU keeping the scheduling-clock interrupt going, even if all
	CPUs are otherwise idle.

> Otherwise, document looks great.  
> 
> Reviewed-by: Kevin Hilman <khilman@linaro.org>

Added, thank you for the review and comments!

							Thanx, Paul

