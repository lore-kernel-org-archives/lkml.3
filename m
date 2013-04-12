Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab3DLUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:39:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54653 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3DLUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:39:32 -0400
Date: Fri, 12 Apr 2013 13:39:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Kevin Hilman <khilman@linaro.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
Message-ID: <20130412203904.GL29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130411182502.GA31684@pd.tnic>
 <20130411191355.GO29861@linux.vnet.ibm.com>
 <1365753904.17140.22.camel@laptop>
 <20130412175419.GG29861@linux.vnet.ibm.com>
 <51684AD3.7090305@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51684AD3.7090305@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041220-7606-0000-0000-00000A5C3B67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 10:56:35AM -0700, Arjan van de Ven wrote:
> 
> >------------------------------------------------------------------------
> >
> >1.	It increases the number of instructions executed on the path
> >	to and from the idle loop.
> >
> >2.	On many architectures, dyntick-idle mode also increases the
> >	number of times that clocks must be reprogrammed, and this
> >	reprogramming can be quite expensive.
> 
> 
> it's really that we're no longer using periodic clocks, but only one-shot clocks only.
> (which then leads to having to program them every time)

Fair enough, but I believe that I have captured this.

> but arguably, that's because of HRTIMERS more than NOHZ
> (e.g. I bet we still turn off periodic even for nohz as long as hrtimers are enabled)

Might be, but the more detail I add, the higher the maintenance burden
keeping this document up to date.  ;-)

							Thanx, Paul

