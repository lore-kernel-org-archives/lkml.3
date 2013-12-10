Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3LJU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab3LJU4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:56:25 -0500
Date: Tue, 10 Dec 2013 15:55:23 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210205523.GC27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
	Oleg Nesterov <oleg@redhat.com>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210202752.GA27373@redhat.com>
 <alpine.DEB.2.02.1312102133400.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312102133400.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:34:24PM +0100, Thomas Gleixner wrote:
 
 > >  > PS: Oleg - the whole thread is on lkml. Ping me if you need more context.
 > > 
 > > btw, I've left the machine in that state, and will for as long as necesary
 > > in case someone has any ideas for further tracing experiments.
 > 
 > Can you gather a trace with the function tracer? That will tell us
 > what the thing is actually doing.

Feed me command lines, and I'll see what I can do.

	Dave

