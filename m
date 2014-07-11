Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaGKIXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:23:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaGKIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:23:08 -0400
Date: Fri, 11 Jul 2014 10:23:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH] perf/x86/uncore: fix SNB-EP/IVT Cbox filter mappings
Message-ID: <20140711082302.GA20603@laptop.programming.kicks-ass.net>
References: <20140630144624.GA2604@quad>
 <CABPqkBRBF6TXf3Q5+MvWneKrgtrjZMv3FzW6rVMygz2QvWgowg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRBF6TXf3Q5+MvWneKrgtrjZMv3FzW6rVMygz2QvWgowg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:16:30PM +0200, Stephane Eranian wrote:
> On Mon, Jun 30, 2014 at 4:46 PM, Stephane Eranian <eranian@google.com> wrote:
> >
> > This patch fixes the SNB-EP and IVT Cbox filter mapping
> > table. The table controls which filters are supported by
> > which events. There were several mistakes in those tables
> > causing some filters to be ignored, such as NID on
> > TOR_INSERTS.
> >
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> Any comment on this patch?

I queued, it. I'll try and get it into tip over the weekend or so.
