Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3GRInA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:43:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab3GRIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:42:58 -0400
Date: Thu, 18 Jul 2013 10:42:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718084249.GD27075@twins.programming.kicks-ass.net>
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com>
 <51E77F90.3040007@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E77F90.3040007@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 01:39:28PM +0800, Yan, Zheng wrote:
> On 07/18/2013 01:36 PM, Yan, Zheng wrote:
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > Compare to old atom, Silvermont has offcore and has more events
> > that support PEBS.
> > 
> > Silvermont has two offcore response configuration MSRs, but the
> > event code for OFFCORE_RSP_1 is 0x02b7. To avoid complicating
> > intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to define offcore
> > MSRs. So intel_fixup_er() can find the code for OFFCORE_RSP_1
> > by x86_pmu.extra_regs[1].event.
> >
> 
> Document is at http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf, but it has no PEBS event list.

Why isn't this in the regular SDM like all the other stuff?
