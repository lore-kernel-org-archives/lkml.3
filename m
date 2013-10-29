Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3J2MsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 08:48:08 -0400
Received: from mail-gg0-f173.google.com ([209.85.161.173]:37396 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3J2MsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 08:48:06 -0400
Date: Tue, 29 Oct 2013 09:47:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131029124757.GI16948@ghostprotocols.net>
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
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 29, 2013 at 10:50:30AM +0100, Stephane Eranian escreveu:
> On Mon, Oct 28, 2013 at 1:42 PM, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Oct 28, 2013 at 09:34:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> >> And then, when reverting it, Stephane forgot to match the number number
> >> of expected entries to be matched/assigned from 8 to 5, can you try with
> >> the following patch instead?

> > Does the wording on this commit log sounds about right to you?

> Thanks for fixing this issue.

You're welcome! :-)

- Arnaldo
