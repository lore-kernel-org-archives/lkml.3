Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3JaWZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:25:30 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56489 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3JaWZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131031095143.GA9692@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
	<20131024122646.GB2402@suse.de>
	<20131031095143.GA9692@gmail.com>
Date: Thu, 31 Oct 2013 15:25:22 -0700
X-Google-Sender-Auth: yuCHwUPy9SARZcxIS6yiOexySyc
Message-ID: <CA+55aFyDve4RtZ6n11ghFcq1kmzs52OB+xetZjyP1q3RparUkw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] NUMA-balancing memory corruption fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Tom Weber <l_linux-kernel@mail2news.4t2.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 2:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> ( If you think this is too dangerous for too little benefit then
>   I'll drop this separate tree and will send the original commits in
>   the merge window. )

Ugh. I hate hate hate the timing, and this is much larger and scarier
than what I'd like at this point, but I don't see the point to
delaying this either.

So I'm pulling them. And then I may end up doing an rc8 after all.

                 Linus
