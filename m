Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaFWJT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:19:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:46532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaFWJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:19:55 -0400
Date: Mon, 23 Jun 2014 11:19:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Liang, Kan" <kan.liang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
Message-ID: <20140623091952.GP19860@laptop.programming.kicks-ass.net>
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
 <20140618155916.GZ6758@twins.programming.kicks-ass.net>
 <87lhsu8arx.fsf@tassilo.jf.intel.com>
 <87ha3g947f.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha3g947f.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:52:52AM -0700, Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> >>
> >>>     Signed-off-by: Kan Liang <kan.liang@intel.com>
> >>
> >> And here I thought that Andi was of the opinion that if you set CPUID to
> >> indicate a particular CPU you had better also handle all its MSRs.
> >
> > Yes, philosophically that would be the right way,
> > but we needed a short term fix to stop things from crashing, and that
> > was the simplest.
> 
> I should add there is another reason for this patch now,
> and doing it in perf instead of somewhere else
> (this should probably go into the description).
> 
> With PT on enabling LBR can #GP. So perf needs to handle
> this case without crashing. This can happen independently
> of any hypervisors.

WTH is a PT?
