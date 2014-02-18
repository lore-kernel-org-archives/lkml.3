Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaBRLWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:22:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40930 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaBRLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:22:40 -0500
Date: Tue, 18 Feb 2014 12:22:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: paulus@samba.org, Ingo Molnar <mingo@redhat.com>, acme@ghostprotocols.net,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
Message-ID: <20140218112230.GA27965@twins.programming.kicks-ass.net>
References: <5302EBA3.10909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5302EBA3.10909@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:12:03PM +0800, Michael wang wrote:
> Hi, Folks
> 
> Got below panic while testing tip/master on x86 box, it randomly
> occur while booting or rebooting, any ideas?

The obvious pick would be the relocation of the idle_balance call, but
I'm not sure how that'll end up stalling.
