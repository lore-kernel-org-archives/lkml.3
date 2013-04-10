Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935558Ab3DJM4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:56:10 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51331 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964855Ab3DJM4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:56:08 -0400
Date: Wed, 10 Apr 2013 14:56:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Enable function tracing for perf core
Message-ID: <20130410125603.GB12978@gmail.com>
References: <1362785086-12901-1-git-send-email-andi@firstfloor.org>
 <m2y5d7h6kb.fsf@firstfloor.org>
 <1365435422.25498.7.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365435422.25498.7.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2013-03-28 at 08:45 -0700, Andi Kleen wrote:
> > Andi Kleen <andi@firstfloor.org> writes:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > >
> > > According to Steven R. there is no reason left to not support
> > > function tracing for the perf core. This makes it easier to debug
> > > perf.
> > >
> > > Don't remove -pg for the x86 and generic perf core.
> > 
> > Ping! patch is missing review.
> > 
> 
> This needs an acked-by from either Peter or Frederic.

I think this was mentioned before: there was measurable overhead due to this, so 
that has to be re-measured.

Thanks,

	Ingo
