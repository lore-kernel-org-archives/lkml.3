Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbaGXO6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:58:52 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38887 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbaGXO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:58:51 -0400
Date: Thu, 24 Jul 2014 16:58:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 2/2] Don't track sysidle state if no
 nohz_full= CPUs
Message-ID: <20140724145842.GB25788@localhost.localdomain>
References: <20140723162851.GA17665@linux.vnet.ibm.com>
 <20140723162951.GA17743@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723162951.GA17743@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:29:51AM -0700, Paul E. McKenney wrote:
> If there are no nohz_full= CPUs, then there is currently no reason to
> track sysidle state.  This commit therefore short-circuits this state
> tracking if !tick_nohz_full_enabled().
> 
> Note that these checks will need to be revisited if nohz_full= state
> can ever be changed at runtime.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
