Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3JaEf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:35:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37807 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab3JaEfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:35:55 -0400
Date: Wed, 30 Oct 2013 21:33:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131031043346.GR4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131030155116.GO16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030155116.GO16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103104-5806-0000-0000-00002345DCE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:51:16PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 03:28:54PM +0200, Victor Kaplansky wrote:
> > one of the authors of Documentation/memory-barriers.txt is on cc: list ;-)
> > 
> > Disclaimer: it is anyway impossible to prove lack of *any* problem.
> > 
> > Having said that, lets look into an example in
> > Documentation/circular-buffers.txt:
> 
> > 
> > We can see that authors of the document didn't put any memory barrier
> 
> Note that both documents have the same author list ;-)
> 
> Anyway, I didn't know about the circular thing, I suppose I should use
> CIRC_SPACE() thing :-)

Interesting that we didn't seem to supply a definition...  ;-)

							Thanx, Paul

