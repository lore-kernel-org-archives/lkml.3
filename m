Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3JLRN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:13:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39271 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3JLRNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:13:55 -0400
Date: Sat, 12 Oct 2013 10:13:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, fengguang.wu@intel.com, stephen@networkplumber.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, tgraf@suug.ch, gaofeng@cn.fujitsu.com,
        linux-decnet-user@lists.sourceforge.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH v3 tip/core/rcu 0/14] Sparse-related updates for 3.13
Message-ID: <20131012171345.GB5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131011231659.GA28062@linux.vnet.ibm.com>
 <20131012065326.GG15339@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012065326.GG15339@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101217-9332-0000-0000-000001BE986B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 11:53:27PM -0700, Josh Triplett wrote:
> On Fri, Oct 11, 2013 at 04:16:59PM -0700, Paul E. McKenney wrote:
> > Changes from v2:
> > 
> > o	Switch from rcu_assign_pointer() to ACCESS_ONCE() given that
> > 	the pointers are all --rcu and already visible to readers,
> > 	as suggested by Eric Dumazet and Josh Triplett.
> 
> Hang on a moment.  Do *none* of these cases need write memory barriers?

Sigh.  Some afternoons it doesn't pay to touch the keyboard.

Thank you for catching this.  I will fix, but at this point, I am thinking
in terms of 3.14 rather than 3.13 for this series.

							Thanx, Paul

