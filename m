Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBVRdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:33:17 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:47299 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaBVRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:33:16 -0500
Date: Sat, 22 Feb 2014 18:33:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL v2] liblockdep fixes for v3.14
Message-ID: <20140222173311.GA401@gmail.com>
References: <52FBFEE8.3010708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FBFEE8.3010708@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> The following changes since commit 65370bdf881e20907e7a53abab9b8c0bc5f60a6b:
> 
>   Merge branch 'linus' into core/locking (2014-02-02 09:43:20 +0100)

That's not a suitable base commit for upstream fixes (because it 
brings in tip:core/locking changes destined for v3.15!) - please use 
tip:core/urgent or one of Linus's -rc's.

Also, I found some more commit log problems.

1)

This:

    Acked-by: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Is redundant - skip the Acked-by.

2)

This:

    [sasha: Modified subject]
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

should in general be:

    [ Modified subject. ]
    Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Because it's obvious from the placement of the bracketed line that the 
comment is from you, no need to prefix it with 'sasha:'.

But ... more importantly, small commit log edits are typical (and 
expected) from maintainers - I do it for 99% of the patches that I 
apply, so please only add such comments if it goes outside the usual 
pattern:

   - if you've written a completely new changelog (nice from you)

   - or if you've resolved conflicts when applying the patch or 
     actually changed the code logic compared to what was submitted 
     (which should always be declared).

Thanks,

	Ingo
