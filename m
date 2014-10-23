Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaJWNNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:13:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbaJWNNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:13:43 -0400
Date: Thu, 23 Oct 2014 15:13:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf,x86: De-obfuscate HSW offcore bits
Message-ID: <20141023131321.GK3219@twins.programming.kicks-ass.net>
References: <20141023105119.173457103@infradead.org>
 <20141023105658.111371548@infradead.org>
 <20141023121619.GB4643@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023121619.GB4643@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 02:16:19PM +0200, Borislav Petkov wrote:
> On Thu, Oct 23, 2014 at 12:51:20PM +0200, Peter Zijlstra wrote:
> > Andi introduced the HSW cache events array, but used magic constants
> > against convention as set by all the other uarchs. Try and deobfuscate
> > these a bit.
> > 
> > This patch should not change the actual values generated; however
> > weird they seems.
> > 
> > In that patch Andi also said there were differences between the
> > SNB/IVB and HSW/BDW offcore tables but failed to specify which and
> > why.
> > 
> > Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Stephane Eranian <eranian@google.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Link: http://lkml.kernel.org/n/tip-@git.kernel.org
> 
> This link looks funny.

Yes it does, I seem to have not isntalled rndpwd or whatever that script
is using. Also I usually grep -v "^Link:" .mbox files before sending,
guess what I forgot :-)
