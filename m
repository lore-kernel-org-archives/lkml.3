Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3ILUCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:02:46 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36872 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3ILUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:02:42 -0400
Date: Thu, 12 Sep 2013 17:02:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912200236.GC11400@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52321CE4.1080804@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 12, 2013 at 12:58:28PM -0700, David Ahern escreveu:
> On 9/12/13 11:43 AM, Arnaldo Carvalho de Melo wrote:
> >Its something that annoys me as well, but not so much as to make me
> >figure out how to make those be done only if some source file changed.
> 
> Jiri and I have both taken stabs at a config-based build rather than
> probing. Just need to finish it.

But even then it would be nice to have a:

make autoconfig

That is what we have now, but only then we would try to do all that
probing. Caching it somehow, as Ingo suggested, would get the best of
both worlds.

- Arnaldo
