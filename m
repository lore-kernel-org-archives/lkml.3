Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3K0KXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:23:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46001 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3K0KXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:23:35 -0500
Date: Wed, 27 Nov 2013 11:23:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131127102310.GX10022@twins.programming.kicks-ass.net>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
 <1384275531-10892-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384275531-10892-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 05:58:50PM +0100, Stephane Eranian wrote:
> Sampling is not supported by the RAPL PMU. There is no
> privilege level filtering either.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

So the merge window closed and we're starting to merge new bits for the
next cycle.

Ingo fell over the double SoB here; Maria didn't actually send me this
patch, so the SoB seems awkward at best.

Sob only comes from being the primary author or from collecting it in an
aggregate work and passing it on.

I know people often use this double sob for co-authorship (even on
single line patches), but its not supported by the rules as outlined in
Documentation/SubmittingPatches.

So Ingo changed it to a Reviewed-by tag if that's fine with you -
further credits should be expressed either as split-out patches that
track authorship, or additional credits in the source code.
