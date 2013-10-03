Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3JCGn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:43:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50926 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3JCGnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:43:55 -0400
Date: Thu, 3 Oct 2013 08:43:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: Re: PERF_EVENT_IOC_SET_OUTPUT
Message-ID: <20131003064351.GG25345@gmail.com>
References: <524B1E7C.3070108@intel.com>
 <20131002100350.GO3081@twins.programming.kicks-ass.net>
 <20131002102954.GD7941@localhost.localdomain>
 <20131002112730.GQ3081@twins.programming.kicks-ass.net>
 <20131002122900.GA27811@gmail.com>
 <20131002124023.GC28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002124023.GC28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 02, 2013 at 02:29:01PM +0200, Ingo Molnar wrote:
> > 
> > Btw., this does not seem to be working very well when the perf context is 
> > inherited:
> 
> https://lkml.org/lkml/2011/7/21/124
> 
> Never figured that one out :-(

Hm, maybe the various fixes over the past 2.5 years would make it work 
today?

If you find time to send an updated version that boots then I can try to 
trace it to figure out where it fails, if it still fails.

Thanks,

	Ingo
