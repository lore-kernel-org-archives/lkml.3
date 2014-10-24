Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaJXJji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:39:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaJXJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:39:37 -0400
Date: Fri, 24 Oct 2014 11:39:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kan Liang <kan.liang@intel.com>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V6 01/17] perf, x86: Reduce lbr_sel_map size
Message-ID: <20141024093930.GD12706@worktop.programming.kicks-ass.net>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413755712-8259-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 05:54:56PM -0400, Kan Liang wrote:

This should still very much have:

From: Yan, Zheng <zheng.z.yan@intel.com>

Seeing how you did not write this patch, probably true for all the
others too, although I've not checked yet.

> The index of lbr_sel_map is bit value of perf branch_sample_type.
> PERF_SAMPLE_BRANCH_MAX is 1024 at present, so each lbr_sel_map uses
> 4096 bytes. By using bit shift as index, we can reduce lbr_sel_map
> size to 40 bytes. This patch defines 'bit shift' for branch types,
> and use 'bit shift' to define lbr_sel_maps.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Reviewed-by: Stephane Eranian <eranian@google.com>
> ---

