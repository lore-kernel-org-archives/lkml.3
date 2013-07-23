Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3GWHpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:45:11 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:59924 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3GWHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:45:09 -0400
Date: Tue, 23 Jul 2013 09:45:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org
Subject: Re: Re: [PATCH -tip/x86/jumplabel] x86: call out into int3 handler
 directly instead of using notifier
Message-ID: <20130723074505.GA15255@gmail.com>
References: <20130720131226.GA13893@localhost>
 <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz>
 <51ED9BC0.6020206@linux.intel.com>
 <alpine.LNX.2.00.1307222256120.14024@pobox.suse.cz>
 <51EDDB4B.6030609@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EDDB4B.6030609@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/07/23 6:00), Jiri Kosina wrote:
> > On Mon, 22 Jul 2013, H. Peter Anvin wrote:
> > 
> >>  What is the baseline for this patch?
> > 
> > Hi!
> > 
> > it's x86/jumplabel branch, as a followup to commit 
> > fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based instruction 
> > patching") sitting there.
> 
> AFAICS, tip/master already merged Jiri's works on tip/x86/jumplabel.
> Thus both branches need this. (especially, since this is actual
> bugfix, it should go into tip/master.)

I resolved it yesterday by keeping the kprobes patches in perf/core - just 
forgot to push it all out.

I've pushed it out now, so perf/core should be a baseline: it merges in 
x86/jumplabel and then applies the kprobes patches (historically in 
perf/core).

Thanks,

	Ingo
