Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3KTRT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:19:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:33194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab3KTRTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:19:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="411900801"
Date: Wed, 20 Nov 2013 09:19:21 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/7] Cure some vaux idle wrackage
Message-ID: <20131120091921.2da67ff3@ultegra>
In-Reply-To: <20131120163453.GS10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
	<20131120163453.GS10022@twins.programming.kicks-ass.net>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 17:34:53 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 20, 2013 at 05:04:50PM +0100, Peter Zijlstra wrote:
> > I ran head-first into intel_powerclamp and acpi_pad yesterday --
> > afaict they try and do pretty much the same thing but both had
> > competing sets of bugs and issues.
> > 
> > Related to that I went over the tree looking for
> > preempt_enable_no_resched() abuse.
> > 
> > I know that patch 3 isn't going to be popular with Arjan but you
> > guys are going to have to make that work. That stuff is hideously
> > terrible.
> > 
> > A note to Zhang Rui, _never_ merge EXPORTs in another maintainers'
> > guts without an explicit ACK from him, Thomas was quite horrified
> > when I asked him how tick_nohz_idle_{enter,exit} got exported.
> > 
> > That said, thanks for a 'fun' two days :-(
> 
> s/vaux/faux/ .. its been a long day.. and there's far too many dead
> email addresses @intel.com
Hi Peter,
I cannot cleanly apply the patch set on upstream kernel. Failed on
Subject: [PATCH 4/7] preempt, locking: Rework local_bh_{dis,en}able()

Can you tell me which commit id should I do git am?

Thanks,

Jacob
