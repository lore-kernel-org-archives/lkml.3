Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3CUL2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:28:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59889 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3CUL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:28:39 -0400
Date: Thu, 21 Mar 2013 12:28:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v9
Message-ID: <20130321112835.GA23567@gmail.com>
References: <1362786573-18455-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362786573-18455-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> This is based on v7 of the full Haswell PMU support,
> rebased, reviewer-optimized and stripped down to the bare bones
> 
> Most interesting new features are not in this patchkit
> (full version is git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)
> 
> Contains support for:
> - Basic Haswell PMU and PEBS support
> - Late unmasking of the PMI
> - Basic LBRv4 support
> 
> v2: Addressed Stephane's feedback. See individual patches for details.
> v3: now even more bite-sized. Qualifier constraints merged earlier.
> v4: Rename some variables, add some comments and other minor changes.
> Add some Reviewed/Tested-bys.
> v5: Address some minor review feedback. Port to latest perf/core
> v6: Add just some variable names, add comments, edit descriptions, some
> more testing, rebased to latest perf/core
> v7: Expand comment
> v8: Rename structure field.
> v9: No wide counters, but add basic LBRs. Add some more 
> constraints. Rebase to 3.9rc1

I had another look at your latest patches and they are still quite sloppy: 
you never ran them through checkpatch.pl, right? Tons of warnings, quite a 
few of which are legitimate.

These are all basic kernel hacking 101 mistakes you commited and we are 
already into version 9 of your patch-set ...

Having to point out trivial errors in your patches again and again is not 
a very efficient use of my time, frankly.

Thanks,

	Ingo
