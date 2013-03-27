Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3C0TX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:23:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59036 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3C0TX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:23:58 -0400
Date: Wed, 27 Mar 2013 12:22:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327192217.GE4379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <20130327131532.GL30540@8bytes.org>
 <1364393852.5053.74.camel@laptop>
 <20130327143715.GY4379@linux.vnet.ibm.com>
 <20130327163427.GN30540@8bytes.org>
 <20130327163806.GC8385@pd.tnic>
 <20130327180455.GA4379@linux.vnet.ibm.com>
 <20130327190727.GD8385@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327190727.GD8385@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032719-2876-0000-0000-000006D06F8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 08:07:27PM +0100, Borislav Petkov wrote:
> On Wed, Mar 27, 2013 at 11:04:55AM -0700, Paul E. McKenney wrote:
> > On Wed, Mar 27, 2013 at 05:38:06PM +0100, Borislav Petkov wrote:
> > > On Wed, Mar 27, 2013 at 05:34:27PM +0100, Joerg Roedel wrote:
> > > > Interesting read, thanks guys. I think I should have a look into the
> > > > tree-preempt implementation and try to understand it :)
> > > 
> > > Hurry, before paulmck comes and changes it unrecognizable! :-)
> > 
> > Better yet, review my changes for 3.10.  ;-)
> 
> Oh, and if one needs to brush up on RCU while doing that, there's this
> cool thing called perfbook (whole title is too long :)) I discovered
> while searching for your 3.10 queue on k.org. :-)

Reviews of perfbook are also welcome.  ;-)

In case you didn't find it, the 3.10 queue is at rcu/next in:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

The corresponding LKML posts may be found at:

	https://lkml.org/lkml/2013/3/18/960
	https://lkml.org/lkml/2013/3/18/570
	https://lkml.org/lkml/2013/3/18/594

							Thanx, Paul

