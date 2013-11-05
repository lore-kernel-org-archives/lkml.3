Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3KETiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:38:24 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41635 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KETiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:38:23 -0500
MIME-Version: 1.0
In-Reply-To: <20131105105244.666320103@infradead.org>
References: <20131105105244.666320103@infradead.org>
Date: Tue, 5 Nov 2013 11:38:22 -0800
Message-ID: <CANN689HGoJHeQ0HZ4VC1eS0_yFpjCwryHCfwgmHVw_CsstPF1g@mail.gmail.com>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 4:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi all,
>
> During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
> locking bits.
>
> To remedy this Ingo suggested gathering all the various locking primitives and
> lockdep into a single place: kernel/locking/.

I quite like the idea.

> I would further like to propose a MAINTAINERS entry like:
>
> LOCKING
> M:      Ingo Molnar <mingo@redhat.com>
> M:      Peter Zijlstra <peterz@infradead.org>
> M:      Oleg Nesterov <oleg@redhat.com>
> M:      "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> M:      Linus Torvalds <torvalds@linux-foundation.org>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
> S:      Maintained
> F:      kernel/locking/
>
> Because for most 'fun' locking discussions we usually end up with at least
> those people anyway :-)

Agree :)

While I don't think I carry as much weight as these people, I was
going to ask to be included here for the fun discussions - and then I
realized that having a separate directory for these files makes it
super easy to set up a mail filter anyway :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
