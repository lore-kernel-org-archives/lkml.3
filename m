Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3GBF6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:58:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42300 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3GBF6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:58:52 -0400
Date: Mon, 1 Jul 2013 22:58:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 2/7] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130702055839.GZ3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130701153150.GB2923@leaf>
 <20130701155220.GL3773@linux.vnet.ibm.com>
 <20130701181601.GA7964@jtriplet-mobl1>
 <20130701182326.GQ3773@linux.vnet.ibm.com>
 <20130701183412.GA18804@jtriplet-mobl1>
 <20130701191656.GR3773@linux.vnet.ibm.com>
 <1372741852.7363.110.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372741852.7363.110.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070205-4834-0000-0000-0000089C13C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 07:10:52AM +0200, Mike Galbraith wrote:
> On Mon, 2013-07-01 at 12:16 -0700, Paul E. McKenney wrote: 
> > On Mon, Jul 01, 2013 at 11:34:13AM -0700, Josh Triplett wrote:
> 
> > > > > This also naturally raises the question "How can we let userspace get
> > > > > accurate time without forcing a timer tick?".
> > > > 
> > > > We don't.  ;-)
> > > 
> > > We don't currently, hence my question about how we can. :)
> > 
> > Per-CPU atomic clocks?
> 
> Great idea, who needs timekeeping code. 
> 
> http://www.euronews.com/2013/04/02/swiss-sets-sights-on-miniscule-atomic-clock/

"in theory you’ll only need to set it once every 3,000 years, providing
of course your battery lasts that long" ;-) ;-) ;-)

							Thanx, Paul

