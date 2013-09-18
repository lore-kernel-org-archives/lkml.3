Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3IROR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:17:57 -0400
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:47138 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462Ab3IRORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:17:55 -0400
Date: Wed, 18 Sep 2013 10:19:32 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
In-Reply-To: <20130918085722.GL12926@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com> <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org> <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy> <20130918085722.GL12926@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.5239B613.0034,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Peter Zijlstra wrote:

> > This patch somehow breaks the perf-ABI.
> 
> Difficult call that..

OK, let me rephrase.

This change broke existing working code.

Can you point to any code that is fixed by the commit?

If not, I think the rule is you revert the changeset.

Or you can just mark the bug "Won't fix, perf tool doesn't use it" I guess

You guys told me to start running my tests in -rc1 so I can catch bugs 
early enough to fix things.  So here I am, finding a problem in -rc1.
If no one cares I'll stop bothering and go back to just documenting the 
problems after the fact in complaining webpages.

Vince
