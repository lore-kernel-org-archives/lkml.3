Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab3HSOjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:39:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33430 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3HSOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:39:35 -0400
Date: Mon, 19 Aug 2013 16:39:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, x86: use INTEL_UEVENT_EXTRA_REG to define
 MSR_OFFCORE_RSP_X
Message-ID: <20130819143924.GG24092@twins.programming.kicks-ass.net>
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBRjJDOcFWOvZw6CTokrLbg5X=p8KCxZYQ47yRGYbdY_Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRjJDOcFWOvZw6CTokrLbg5X=p8KCxZYQ47yRGYbdY_Pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 04:24:56PM +0200, Stephane Eranian wrote:
> On Thu, Jul 18, 2013 at 11:02 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> >
> > Silvermont (22nm Atom) has two offcore response configuration MSRs,
> > unlike other Intel CPU, its event code for MSR_OFFCORE_RSP_1 is 0x02b7.
> > To avoid complicating intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to
> > define MSR_OFFCORE_RSP_X. So intel_fixup_er() can find the event code
> > for OFFCORE_RSP_N by x86_pmu.extra_regs[N].event.
> >
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> 
> Works for me on IVB and NHM.
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>

Thanks guys, and sorry for getting them lost in the inbox :/
