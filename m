Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaAVTjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaAVTjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:39:42 -0500
Date: Wed, 22 Jan 2014 20:39:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: uninline rcu_lock_acquire/etc ?
Message-ID: <20140122193928.GA2634@redhat.com>
References: <20140120181942.GA20783@redhat.com> <20140120182019.GA26515@redhat.com> <20140121141022.GX31570@twins.programming.kicks-ass.net> <20140121173534.GA25642@redhat.com> <20140121184310.GA24702@redhat.com> <20140121193909.GA17497@redhat.com> <20140122035440.GW10038@linux.vnet.ibm.com> <20140122183125.GA31289@redhat.com> <20140122193439.GA9766@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122193439.GA9766@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Paul E. McKenney wrote:
>
> On Wed, Jan 22, 2014 at 07:31:25PM +0100, Oleg Nesterov wrote:
> >
> > Also, this all should be exported. And I think cleanuped somehow.
>
> I would be happy to take a patch with the above issues fixed.

Yes, yes, thanks.

Sorry for noise, I forgot to say that of course I'll try to make v2,
but I will be offline a couple of days.

Oleg.

