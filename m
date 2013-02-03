Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3BCKw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 05:52:29 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53781 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3BCKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 05:52:26 -0500
Date: Sun, 3 Feb 2013 11:52:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers
 v3
Message-ID: <20130203105221.GE9330@gmail.com>
References: <1359672710-19528-1-git-send-email-andi@firstfloor.org>
 <1359672710-19528-5-git-send-email-andi@firstfloor.org>
 <20130201101628.GB23061@gmail.com>
 <20130201150302.GN30577@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201150302.GN30577@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > As requested before, please keep those in a completely 
> > separate series so that minimal support can be merged 
> > upstream. This is
> 
> Hi Ingo, The goal is not to merge "minimal support" but full 
> support.

Stop these idiotic excuses and stop the obstruction already!

Firstly, it is long standing kernel maintenance policy to first 
go for supporting existing applications, ABIs, binaries.

The bulks of your other changes need changes to the ABI and 
changes to tools - and won't be made use of by any of the 
existing installed base of profiling tooling.

It is entirely reasonable and in fact required of me to separate 
out and handle those in a second wave of changes, and this is 
the fourth time you hinder Haswell support by not addressing 
maintainer feedback.

Every other perf contributor understands those concepts.

Secondly, as it's being demonstrated in this discussion again, 
you are a historically problematic contributor who often 
produces avoidably crappy code that needs several iterations to 
get right. You also have a track record of not willing to 
improve and you have a track record of being needlessly 
argumentative and disruptive. All in one, I currently cannot 
trust your code and refuse to handle long, complex patch series 
from you.

Thanks,

	Ingo
