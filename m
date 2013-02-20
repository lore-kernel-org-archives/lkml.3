Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab3BTJSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:18:06 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51223 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3BTJSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:18:03 -0500
Date: Wed, 20 Feb 2013 10:17:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fix for v3.9
Message-ID: <20130220091758.GB18213@gmail.com>
References: <20130219141642.GA12928@gmail.com>
 <CA+55aFwR=p9YL0UKo3E_e1PRZvga8TeWLbqQGvwTzKGaazHrvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwR=p9YL0UKo3E_e1PRZvga8TeWLbqQGvwTzKGaazHrvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Feb 19, 2013 at 6:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest perf-urgent-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> >
> >    HEAD: e97cbe3edf7d88aad4c21dd3de124d9f9d039881 perf/hwbp: Fix cleanup in case of kzalloc() failure
> >
> > Leftover fix from the v3.8 cycle.
> 
> This was already in the other (big) perf pull, as commit 
> 02e176af92f3

Oops, sorry - Arnaldo picked up the fix too and I never noticed 
the overlap.

Thanks,

	Ingo
