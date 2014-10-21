Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaJULRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:17:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaJULRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:17:33 -0400
Date: Tue, 21 Oct 2014 13:17:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 05/12] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20141021111719.GW23531@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:39PM +0200, Stephane Eranian wrote:
> +struct intel_excl_cntrs {
> +	spinlock_t	lock;
> +
> +	struct intel_excl_states states[2];
> +
> +	int		refcnt;		/* per-core: #HT threads */
> +	unsigned	core_id;	/* per-core: core id */
> +};

lkml.kernel.org/r/20140605074753.GG3213@twins.programming.kicks-ass.net

lkml.kernel.org/r/CABPqkBR=+xf-yT7+ouNzVp_TdBYpjeNYpCYc+H7fOMFxPuzyog@mail.gmail.com
