Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944Ab3JQVdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:33:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36003 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289Ab3JQVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:33:03 -0400
Date: Thu, 17 Oct 2013 23:32:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017213253.GA10651@twins.programming.kicks-ass.net>
References: <20131016200924.GA23214@redhat.com>
 <20131016202822.GI2675@laptop.programming.kicks-ass.net>
 <20131016204348.GA25121@redhat.com>
 <20131016205807.GG10651@twins.programming.kicks-ass.net>
 <20131016205800.GB26066@redhat.com>
 <20131016211613.GJ10651@twins.programming.kicks-ass.net>
 <20131017152027.GA14098@redhat.com>
 <20131017152717.GA15308@redhat.com>
 <20131017164707.GV10651@twins.programming.kicks-ass.net>
 <20131017182417.GA17753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017182417.GA17753@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 08:24:17PM +0200, Oleg Nesterov wrote:
> Subject: [PATCH] perf: Factor out strncpy() in perf_event_mmap_event()
> From: Oleg Nesterov <oleg@redhat.com>
> Date: Thu, 17 Oct 2013 20:04:17 +0200
> 
> While this is really minor, but strncpy() does the unnecessary
> zero-padding till the end of tmp[16] and it is called every time
> we are going to use the string literal.
> 
> Turn these strncpy()'s into the single strlcpy() under the new
> label, saves 72 bytes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sure why not.. applied, thanks!
