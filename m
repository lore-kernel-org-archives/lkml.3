Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaIATFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:05:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaIATFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:05:38 -0400
Date: Mon, 1 Sep 2014 21:05:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, Yan@leverpostej.cambridge.arm.com,
        Zheng <zheng.z.yan@intel.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140901190534.GC5806@worktop.ger.corp.intel.com>
References: <20140901181808.GA6427@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901181808.GA6427@leverpostej>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 07:18:08PM +0100, Mark Rutland wrote:
> Hi all,

> [   66.780759]  [<ffffffff8109dd33>] rcu_process_callbacks+0x1e3/0x540

> Has anything seen anything like this before? Is this a known issue?

I've not seen it reported.. sounds like 'fun' though.
