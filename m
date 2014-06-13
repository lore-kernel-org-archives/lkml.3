Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaFMQKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:10:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:49386 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaFMQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:10:32 -0400
Date: Fri, 13 Jun 2014 18:10:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140613145531.GA31794@redhat.com>
Message-ID: <alpine.DEB.2.10.1406131809570.5170@nanos>
References: <alpine.DEB.2.10.1406102210580.5170@nanos> <20140611155251.GA4581@linux.vnet.ibm.com> <20140611170705.GA26816@redhat.com> <20140611171734.GA27457@redhat.com> <20140611172958.GF4581@linux.vnet.ibm.com> <20140611175934.GA28912@redhat.com>
 <20140611195613.GM4581@linux.vnet.ibm.com> <20140612172844.GA15795@redhat.com> <20140612203518.GZ4581@linux.vnet.ibm.com> <alpine.DEB.2.10.1406122337060.5170@nanos> <20140613145531.GA31794@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Oleg Nesterov wrote:

> On 06/12, Thomas Gleixner wrote:
> >
> > Just FYI, I have a patch pending which makes the release safe.
> >
> >       http://marc.info/?l=linux-kernel&m=140251240630730&w=2
> 
> Aha, great. I didn't see this version, and just in case I think it is fine.
> 
> Perhaps you can look at http://marc.info/?t=140207370200003 ?

Looks good. Should I queue it with the other rtmutex stuff?

Thanks,

	tglx
