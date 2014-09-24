Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaIXKuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:50:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaIXKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:50:34 -0400
Date: Wed, 24 Sep 2014 12:50:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, acme@kernel.org, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 01/16] perf, x86: Reduce lbr_sel_map size
Message-ID: <20140924105024.GW6758@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-2-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358153-421-2-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:08:58AM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>

Uhm, I'm very sure Zheng Yan wrote this.. you cannot just add your from
on that.

> 
> The index of lbr_sel_map is bit value of perf branch_sample_type.
> PERF_SAMPLE_BRANCH_MAX is 1024 at present, so each lbr_sel_map uses
> 4096 bytes. By using bit shift as index, we can reduce lbr_sel_map
> size to 40 bytes. This patch defines 'bit shift' for branch types,
> and use 'bit shift' to define lbr_sel_maps.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Reviewed-by: Stephane Eranian <eranian@google.com>

And you're sending me this patch, so I would have expected a SoB from
you here.
