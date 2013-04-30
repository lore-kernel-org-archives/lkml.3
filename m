Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3D3S46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350Ab3D3S4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:56:54 -0400
Date: Tue, 30 Apr 2013 20:53:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] (Was: ptrace: PTRACE_DETACH should do
	flush_ptrace_hw_breakpoint(child))
Message-ID: <20130430185322.GA12389@redhat.com>
References: <20130418184350.GA4407@redhat.com> <20130418184425.GA4454@redhat.com> <20130429160931.GD31230@somewhere> <20130429164038.GA27132@redhat.com> <20130429233647.GD1760@somewhere> <20130430175138.GA30014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430175138.GA30014@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Oleg Nesterov wrote:
>
> On 04/30, Frederic Weisbecker wrote:
> >
> > > Btw. perhaps flush_ptrace_hw_breakpoint() should also clear the
> > > virtual registers like thread.debugreg7 ? Even without this patch,
> > > flush_ is also called exec.
> >
> > Yeah makes sense.
>
> OK, and probably debugreg6 too, but I need to recheck.

Yes, looks like it should be cleared and we did this before.

And I think this change makes sense in this series, so could you
review this patch too?

Oleg.

