Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3JDKzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:55:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JDKzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:55:49 -0400
Date: Fri, 4 Oct 2013 12:55:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [RFC PATCH 0/7] perf, x86: Reduce lbr_sel_map size
Message-ID: <20131004105535.GH3081@twins.programming.kicks-ass.net>
References: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:28:06PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are executed
> the last captured branch record is popped from the on-chip LBR registers.
> The LBR call stack facility can help perf to get call chains of progam 
> without frame pointer. When perf tool requests PERF_SAMPLE_CALLCHAIN +
> PERF_SAMPLE_BRANCH_USER, this feature is dynamically enabled by default.
> This feature can be disabled/enabled through an attribute file in the cpu
> pmu sysfs directory.
> 
> The main change since previous patch series is:
>  Patch 3 introduces PMU context switch callback, and uses the callback to
>  unify the flush branch stack codeo.
> 
>  Patch 4 uses the context switch callback to save/restore the LBR stack.

>From what I can tell this is the exact same drivel I rejected earlier.

Same shitty changelogs, same shitty code.

Do not waste my time like this.
