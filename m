Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3JBRgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:36:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53001 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3JBRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:36:36 -0400
Date: Wed, 2 Oct 2013 19:36:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131002173619.GW3081@twins.programming.kicks-ass.net>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
 <20131002085730.GD12926@twins.programming.kicks-ass.net>
 <20131002172507.GG2125@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002172507.GG2125@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 10:25:07AM -0700, Andi Kleen wrote:
> > Why are you doing this; also what's up with 11/11?
> 
> I was playing with a static checker, and posted some
> of the fixes from looking at the warnings.
> There were 11 patches in the series
> 
> Only one is perf related.

It would help to know what the reported 'error' was. It wasn't at all
clear to me what we were trying to do and why there would be a problem.
