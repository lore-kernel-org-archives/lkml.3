Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaAUUGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:06:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaAUUGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:06:18 -0500
Date: Tue, 21 Jan 2014 21:06:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
	single argument
Message-ID: <20140121200603.GA18567@redhat.com>
References: <20140120181942.GA20783@redhat.com> <20140120182019.GA26515@redhat.com> <20140121141022.GX31570@twins.programming.kicks-ass.net> <20140121173534.GA25642@redhat.com> <20140121184310.GA24702@redhat.com> <20140121135306.7c01892c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121135306.7c01892c@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Steven Rostedt wrote:
>
> On Tue, 21 Jan 2014 19:43:10 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Do you mean __attribute__((packed)) ?
>
> I think Dave means:
>
> 	unsigned char subclass	: 3;
> 	unsigned char trylock	: 1;
> 	unsigned char read	: 2;
> 	unsigned char check	: 1;

Ah, yes. But I don't think this will change the code generation.

Oleg.

