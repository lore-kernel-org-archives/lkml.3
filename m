Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaHDNcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:32:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaHDNcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:32:12 -0400
Date: Mon, 4 Aug 2014 15:29:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804132927.GB18722@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140801141144.GA30293@redhat.com> <20140801182837.GI4784@linux.vnet.ibm.com> <20140801184059.GB10718@redhat.com> <20140802230020.GD8101@linux.vnet.ibm.com> <20140803125758.GA671@redhat.com> <20140803220327.GG8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140803220327.GG8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Paul E. McKenney wrote:
>
> If I understand correctly, your goal is to remove a synchronize_sched()
> worth of latency from the overall RCU-tasks callback latency.  Or am I
> still confused?

Yes, exactly. But again, I am not sure this minor optimization makes sense,
mostly I tried to check my understanding.

Oleg.

