Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3HLPSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:18:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab3HLPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:18:14 -0400
Date: Mon, 12 Aug 2013 17:18:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
Message-ID: <20130812151809.GN27162@twins.programming.kicks-ass.net>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
 <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBRsKQLDjH_mynbeOQyX+_QEbuiPKF_Jv5tebqmYL090ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRsKQLDjH_mynbeOQyX+_QEbuiPKF_Jv5tebqmYL090ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:53:53AM +0200, Stephane Eranian wrote:
> On Wed, Aug 7, 2013 at 8:17 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> >
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> >
> > PCU uncore event control register has a undocumented ev_sel_ext bit.
> > The bit is needed by Andi's pmu-tools.
> >
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> 
> 
> Works for me. Is also needed by libpfm4 uncore PCU events.
> Now results make more sense. Please apply.
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>

Seriously guys; how am I going to justify merging a changelog that
reads: Provides magic bit to sprinkle fairy dust; required by $people. ?


