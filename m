Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3J2KVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:21:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3J2KVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:21:53 -0400
Date: Tue, 29 Oct 2013 11:21:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131029102131.GA16117@laptop.programming.kicks-ass.net>
References: <12083.1382486094@ale.ozlabs.ibm.com>
 <20131023141948.GB3566@localhost.localdomain>
 <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:58:58PM +0200, Victor Kaplansky wrote:
> Oleg Nesterov <oleg@redhat.com> wrote on 10/28/2013 10:17:35 PM:
> 
> >       mb();   // XXXXXXXX: do we really need it? I think yes.
> 
> Oh, it is hard to argue with feelings. Also, it is easy to be on
> conservative side and put the barrier here just in case.

I'll make it a full mb for now and too am curious to see the end of this
discussion explaining things ;-)
