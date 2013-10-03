Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JCGmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:42:07 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46807 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3JCGmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:42:04 -0400
Date: Thu, 3 Oct 2013 08:42:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 11/11] perf: Avoid uninitialized sample type reference in
 __perf_event__output_id_sample
Message-ID: <20131003064201.GF25345@gmail.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-12-git-send-email-andi@firstfloor.org>
 <20131002085730.GD12926@twins.programming.kicks-ass.net>
 <20131002172507.GG2125@tassilo.jf.intel.com>
 <20131002173619.GW3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002173619.GW3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 02, 2013 at 10:25:07AM -0700, Andi Kleen wrote:
> > > Why are you doing this; also what's up with 11/11?
> > 
> > I was playing with a static checker, and posted some
> > of the fixes from looking at the warnings.
> > There were 11 patches in the series
> > 
> > Only one is perf related.
> 
> It would help to know what the reported 'error' was. [...]

Forcing multiple, unnecessary rounds of emails instead of clearly 
volunteering all technical information that is related to the matter is 
something Andi is still doing routinely.

To deal with this repeat anomaly of Andi's communication patterns I'll 
just reply with a form letter in the future:

 " Your mail or patch is intentionally or accidentally missing key bits of 
   technical information. The kernel list is an open technical forum where
   volunteering as much useful information as possible about a specific
   technical matter _before_ a maintainer asks for it is strongly favored.

   The kernel is not a need-to-know security agency where people are 
   routinely faking superior expertise by holding back and hoarding
   information, forcing others to request that information piecemail wise. "

 Thanks,

	Ingo
