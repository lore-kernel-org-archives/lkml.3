Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaGaT3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:29:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:11758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaGaT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,774,1400050800"; 
   d="scan'208";a="463709047"
From: Andi Kleen <andi@firstfloor.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
References: <20140731003914.GA3872@linux.vnet.ibm.com>
Date: Thu, 31 Jul 2014 12:29:36 -0700
In-Reply-To: <20140731003914.GA3872@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Wed, 30 Jul 2014 17:39:14 -0700")
Message-ID: <871tt1qqcf.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> Hello!
>
> This series provides a prototype of an RCU-tasks implementation, which has
> been requested to assist with tramopoline removal.

Is that trampoline removal (whatever it is) important enough to justify
adding that much new (and complicated) code? Are there other potential
users of this? Is the long term maintenance cost justified?
Will RCU keep growing forever?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
