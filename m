Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbbAMTMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:12:22 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:54175 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbAMTMV (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 13 Jan 2015 14:12:21 -0500
Message-ID: <1421176326.2258.8.camel@stgolabs.net>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
From: Davidlohr Bueso <dave@stgolabs.net>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, Pranith Kumar <bobby.prani@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Jan 2015 11:12:06 -0800
In-Reply-To: <54B4D4E7.2030703@de.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
	 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20150108094102.GD29390@twins.programming.kicks-ass.net>
	 <20150108152230.GL5280@linux.vnet.ibm.com>
	 <1420785714.25454.1.camel@stgolabs.net>
	 <20150109134954.GO5280@linux.vnet.ibm.com>
	 <20150109135614.GI29390@twins.programming.kicks-ass.net>
	 <54B04F1A.1060401@de.ibm.com>
	 <20150112085957.GA25256@twins.programming.kicks-ass.net>
	 <20150112221232.GG9719@linux.vnet.ibm.com> <54B4D4E7.2030703@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 09:18 +0100, Christian Borntraeger wrote:
> Subject: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)
> 
> Feedback has shown that WRITE_ONCE(x, val) is easier to use than ASSIGN_ONCE(val,x).
> There are no in-tree users yet, so lets change it.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

