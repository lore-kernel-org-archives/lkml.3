Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3GYMad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:30:33 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:37448 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755399Ab3GYMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:30:30 -0400
Date: Thu, 25 Jul 2013 08:31:34 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <20130725100451.GJ27075@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1307250828510.18434@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <20130725100451.GJ27075@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.51F11A65.019B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, Peter Zijlstra wrote:

> I didn't add any fields, this is simply catching up with what was
> already there. But yes, this is very much intended to be compatible.

So those id fields have been there since 2.6.31 and just no one noticed 
the header file comments were wrong?  That's fine then, I just have a lot 
of code and other documentation that needs to be updated then.

> I suppose you're 'complaining' about these changes? Yeah, maybe I should
> have split them up in a separate patch.
>
> ...
> 
> It should be a NOP functionality wise.

yes, it looks like a NOP.  I was just surprised to see code changes (even 
trivial ones) when the commit message only said documentation update.

Vince
