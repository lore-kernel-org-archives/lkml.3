Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3J2KGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:06:30 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44465 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3J2KG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:06:29 -0400
Date: Tue, 29 Oct 2013 11:06:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131029100626.GA25557@gmail.com>
References: <20131026122414.GA25026@gmail.com>
 <20131028082848.GA276@x4>
 <20131028090236.GA274@x4>
 <20131028093430.GB274@x4>
 <20131028123411.GB16948@ghostprotocols.net>
 <20131028124218.GD16948@ghostprotocols.net>
 <CABPqkBSKhwO03Sx7sD+0TSp6wROAWwf0p9A8V2VQZfFh+FD9Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSKhwO03Sx7sD+0TSp6wROAWwf0p9A8V2VQZfFh+FD9Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, Oct 28, 2013 at 1:42 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Mon, Oct 28, 2013 at 09:34:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> >> And then, when reverting it, Stephane forgot to match the number number
> >> of expected entries to be matched/assigned from 8 to 5, can you try with
> >> the following patch instead?
> >
> > Does the wording on this commit log sounds about right to you?
> >
> Thanks for fixing this issue.

Thanks guys for testing it - I just sent the pending fixes to Linus 
so it should soon be resolved upstream as well.

Thanks,

	Ingo
