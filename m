Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3JLGxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:53:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60693 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3JLGxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:53:46 -0400
X-Originating-IP: 50.43.39.152
Date: Fri, 11 Oct 2013 23:53:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20131012065326.GG15339@leaf>
References: <20131011231659.GA28062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011231659.GA28062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 04:16:59PM -0700, Paul E. McKenney wrote:
> Changes from v2:
> 
> o	Switch from rcu_assign_pointer() to ACCESS_ONCE() given that
> 	the pointers are all --rcu and already visible to readers,
> 	as suggested by Eric Dumazet and Josh Triplett.

Hang on a moment.  Do *none* of these cases need write memory barriers?

- Josh Triplet
