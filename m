Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3KEON4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:13:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:54554 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754831Ab3KEONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:13:55 -0500
Date: Tue, 5 Nov 2013 09:13:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131105091351.30d1e913@gandalf.local.home>
In-Reply-To: <20131105132609.GA12146@gmail.com>
References: <20131105105244.666320103@infradead.org>
	<20131105081838.27c7fcd4@gandalf.local.home>
	<20131105132609.GA12146@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 14:26:09 +0100
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> Also, 'kernel lock' brings me back memories of the 'big kernel lock' - 
> while 'kernel locks' brings verb/noun ambiguity and visuals of
> 'kernel locks up'.

Of course "locking" is only a verb, and we get "kernel locking up"
too ;-)

> 
> As for typing legth: kernel/lo<Tab> autocompletion is your friend! :-)
> 
> All in one, I think kernel/locking/ is a better name.

Fine, but I just love the idea of having the choice between a bagel and
cream cheese or with kernel lox.

-- Steve
