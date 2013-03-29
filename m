Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3C2CCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:02:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:57075 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3C2CCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:02:32 -0400
Date: Thu, 28 Mar 2013 22:02:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot
Message-ID: <20130329020238.GC3444@windriver.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
 <1364398359-21990-3-git-send-email-fweisbec@gmail.com>
 <20130328074045.GB24433@gmail.com>
 <20130329002555.GA3444@windriver.com>
 <CAFTL4hzz1jKu0tZn=-d0_csvYM_m9L+eRpw1qmmn30iC7cU=BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFTL4hzz1jKu0tZn=-d0_csvYM_m9L+eRpw1qmmn30iC7cU=BQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot] On 29/03/2013 (Fri 01:39) Frederic Weisbecker wrote:

> 2013/3/29 Paul Gortmaker <paul.gortmaker@windriver.com>:
> > [Re: [PATCH 2/4] nohz: Print final full dynticks CPUs range on boot] On 28/03/2013 (Thu 08:40) Ingo Molnar wrote:
> >
> >>
> >> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >>
> >> > +   cpulist_scnprintf(nohz_ext_buf, sizeof(nohz_ext_buf), nohz_extended_mask);
> >> > +   pr_info("NO_HZ: Experimental full dynticks CPUs: %s.\n", nohz_ext_buf);
> >>
> >> I'd suggest removing the 'experimental' word. We are not sending anything
> >> experimental to Linus: we'll send something that is tested and that we
> >> expect to not break anything. (and which we'll fix if it does)
> >
> > In that case, should we vector a patch through PaulM to clobber these too?
> >
> > $ git grep xperiment |grep rcu
> > kernel/rcutree_plugin.h: printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
> > kernel/rcutree_plugin.h: pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
> > kernel/rcutree_plugin.h: pr_info("\tExperimental polled no-CBs CPUs.\n");
> 
> Hehe, that's indeed what I inspired from ;-)

I was guessing exactly that, which is why I mentioned it.  :)

P.
--
