Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaCFKcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:32:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaCFKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:32:09 -0500
Date: Thu, 6 Mar 2014 11:31:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Lu <zlu@tilera.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tile: Add support for handling PMC hardware
Message-ID: <20140306103158.GJ9987@twins.programming.kicks-ass.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF17@USMAExch1.tad.internal.tilera.com>
 <20140306091102.GG9987@twins.programming.kicks-ass.net>
 <BAB94DBB0E89D8409949BC28AC95914C5D67FFC3@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D67FFC3@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 10:12:54AM +0000, Tony Lu wrote:
> >One thing I didn't spot is a tile irq_work implementation; perf likes to
> >have one.
> 
> We do not have tile irq_work for now. It seems like perf works fine
> even without the arch irq_work. Anyway, we will investigate it, and
> submit it as a separate patch when it gets ready.

Yeah, it does work; I have a note somewhere there's a race without it,
but I lost the relevant details.

I should probably try and reconstruct and either fix or at least
comment :/
