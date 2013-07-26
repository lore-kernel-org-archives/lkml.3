Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3GZDXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:23:03 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:56343 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab3GZDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:23:01 -0400
Date: Thu, 25 Jul 2013 23:24:05 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Adrian Hunter <adrian.hunter@intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
In-Reply-To: <20130725162749.GW27075@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1307252320520.26062@pianoman.cluster.toy>
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <51F0C41C.8080005@intel.com> <alpine.DEB.2.02.1307250832010.18434@pianoman.cluster.toy>
 <20130725162749.GW27075@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.51F1EB94.0079,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, Peter Zijlstra wrote:

> On Thu, Jul 25, 2013 at 08:34:51AM -0400, Vince Weaver wrote:
> > Yes, I meant the addition of the sample_id fields to the existing sample 
> > values.  Though if Peter is right and those have always been there since 
> > the beginning and just not documented then that won't break anything.  
> > The commit message wasn't really as clear as it could be.
> 
> /me writes "I shall write better Changelogs." a hundred times.

yes, sorry, I shouldn't have been so grumpy about it.

After spending 45 minutes digging through the kernel source and other 
documentation it all makes sense now.  The existing manpage even does a 
mildly accurate job of explaining the situation.  It's just I have enough 
trouble keeping up with the large number of recent perf related patches 
without having to spend a lot of time decoding cryptic Changelogs.

Vince

