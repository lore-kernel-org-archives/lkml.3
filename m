Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBSNoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:44:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50546 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbaBSNoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:44:11 -0500
Date: Wed, 19 Feb 2014 13:43:41 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/7] Perf core cleanups for shared perf_event_contexts
Message-ID: <20140219134340.GB19774@e106331-lin.cambridge.arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Thread-Topic: [PATCH 0/7] Perf core cleanups for shared perf_event_contexts
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:44:17PM +0000, Mark Rutland wrote:
> Hi,
> 
> I've been working on adding support for heterogeneous pmus (as would be found
> in big.LITTLE systems) to the arm perf backend, and in the process of doing so
> I've noticed a few issues in the core perf code that would be nice to have
> fixed up. The heterogeneous pmu support is not quite ready, but the core
> changes are independent, so I'm posting them today.
> 
> The first three patches fix up some basic issues which are relevant regardless
> of whether you wish to deal with heterogeneous pmus, though patch two also
> fixes a potential bug when perf_event_contexts are shared by multiple pmus.

Peter,

While you have concerns with the later patches in the series, do you
have any concerns with teh first three (as below), or would you be happy
to take them?

>   perf: fix prototype of find_pmu_context
>   perf: remove redundant pmu assignment
>   perf: kill perf_event_context_type

Thanks,
Mark.
