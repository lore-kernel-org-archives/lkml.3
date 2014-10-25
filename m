Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaJYSWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:22:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46217 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJYSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:21:57 -0400
Message-ID: <1414211424.5196.29.camel@marge.simpson.net>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization
 support
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Date: Sat, 25 Oct 2014 06:30:24 +0200
In-Reply-To: <20141024220423.GB10501@worktop.programming.kicks-ass.net>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
	 <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
	 <20141024084738.GU21513@worktop.programming.kicks-ass.net>
	 <544ABC47.2000700@hp.com>
	 <20141024220423.GB10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-25 at 00:04 +0200, Peter Zijlstra wrote: 
> On Fri, Oct 24, 2014 at 04:53:27PM -0400, Waiman Long wrote:
> > The additional register pressure may just cause a few more register moves
> > which should be negligible in the overall performance . The additional
> > icache pressure, however, may have some impact on performance. I was trying
> > to balance the performance of the pv and non-pv versions so that we won't
> > penalize the pv code too much for a bit more performance in the non-pv code.
> > Doing it your way will add a lot of function call and register
> > saving/restoring to the pv code.
> 
> If people care about performance they should not be using virt crap :-)

I tried some benching recently.. where did they hide the fastpaths? :)

-Mike

