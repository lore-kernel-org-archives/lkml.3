Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaHDNsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:48:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55616 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaHDNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:48:35 -0400
Date: Mon, 4 Aug 2014 06:48:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804134828.GM8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801141144.GA30293@redhat.com>
 <20140801182837.GI4784@linux.vnet.ibm.com>
 <20140801184059.GB10718@redhat.com>
 <20140802230020.GD8101@linux.vnet.ibm.com>
 <20140803125758.GA671@redhat.com>
 <20140803220327.GG8101@linux.vnet.ibm.com>
 <20140804132927.GB18722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804132927.GB18722@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080413-6688-0000-0000-000003C09957
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:29:27PM +0200, Oleg Nesterov wrote:
> On 08/03, Paul E. McKenney wrote:
> >
> > If I understand correctly, your goal is to remove a synchronize_sched()
> > worth of latency from the overall RCU-tasks callback latency.  Or am I
> > still confused?
> 
> Yes, exactly. But again, I am not sure this minor optimization makes sense,
> mostly I tried to check my understanding.

No problem with your understanding!  ;-)

I am not going to include this optimization in the first round, but
I will certainly keep it in mind should grace-period latency from
nearly concurrent updates become a problem.

							Thanx, Paul

