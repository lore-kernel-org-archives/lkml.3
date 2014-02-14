Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaBNQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:21:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49265 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaBNQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:21:42 -0500
Date: Fri, 14 Feb 2014 17:21:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue? (maybe bisect)
Message-ID: <20140214162130.GM27965@twins.programming.kicks-ass.net>
References: <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
 <20140214152132.GD26356@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214152132.GD26356@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:21:32PM +0100, Borislav Petkov wrote:
> Oh, and just in case this is relatively easy to reproduce and in case we
> don't have any other idea, bisection might be another option. I'm not
> saying you should do it right away - I'm just putting it on the table...

I'm fairly sure you're going to hit the patch that introduced the whole
per-cpu preemption thing. Before that not receiving the IPI wasn't as
bad as it is now.
