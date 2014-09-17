Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaIQSIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:08:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:6174 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbaIQSIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,541,1406617200"; 
   d="scan'208";a="601126742"
Date: Wed, 17 Sep 2014 11:02:53 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        kan.liang@intel.com
Subject: Re: [PATCH v2] perf/x86/uncore: update support for client uncore IMC
 PMU
Message-ID: <20140917180253.GV5387@tassilo.jf.intel.com>
References: <20140917090616.GA11281@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917090616.GA11281@quad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:06:16AM +0200, Stephane Eranian wrote:
> 
> This patch restructures the memory controller (IMC) uncore
> PMU support for client SNB/IVB/HSW processors. The main change
> is that it can now cope with more than one PCI device ID per
> processor model. There are many flavors of memory controllers
> for each processor. They have different PCI device ID, yet
> they behave the same w.r.t. the memory controller PMU that
> we are interested in.
> 
> The patch now supports two distinct memory controllers for IVB
> processors: one for mobile, one for desktop.
> 
> In V2, we fix the formatting issues reported by checkpatch.

Patch looks good to me.

-Andi
