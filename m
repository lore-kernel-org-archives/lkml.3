Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3KZJnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:43:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3KZJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:43:01 -0500
Date: Tue, 26 Nov 2013 10:42:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: fengguang.wu@intel.com, "Li, Shaohua" <shaohua.li@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel BUG at drivers/md/raid5.c:693!
Message-ID: <20131126094250.GH10022@twins.programming.kicks-ass.net>
References: <20131123032205.GB20794@localhost>
 <20131125103522.6a1c1b36@notabene.brown>
 <20131125095323.GW10022@twins.programming.kicks-ass.net>
 <20131126153106.6ae734c0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126153106.6ae734c0@notabene.brown>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 03:31:06PM +1100, NeilBrown wrote:
> The stack trace in the previous email seemed to suggest that a process was
> blocking inside a wake_up call, but it wasn't at all conclusive.  And I've
> seen a few wake_ups in other stack traces which seem to be connected with
> other deadlock.  Probably some sort of co-incidence.

It appears stuck in some paravirt clock layer.. or just a lucky hit.

I never run on (para)virt if I can help it, so I'm not much help there.
