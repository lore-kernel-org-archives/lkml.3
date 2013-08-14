Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab3HNKBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:01:08 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47042 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3HNKBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:01:06 -0400
Date: Wed, 14 Aug 2013 12:01:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linus <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the arm-current tree with Linus' tree
Message-ID: <20130814100101.GC10849@gmail.com>
References: <20130814111837.9a692a77b35ba8cbb4a9149b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814111837.9a692a77b35ba8cbb4a9149b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Russell,
> 
> Today's linux-next merge of the arm-current tree got a conflict in 
> arch/arm/kernel/perf_event.c between commit b88a2595b6d8 ("perf/arm: Fix 
> armpmu_map_hw_event()") from Linus' tree and commit d9f966357b14 ("ARM: 
> 7810/1: perf: Fix array out of bounds access in armpmu_map_hw_event()") 
> from the arm-current tree.
> 
> These are the same patch except for the return code (and the much more 
> comprehensive commit message in the arm-current tree version).  I fixed 
> it up (using the arm-current tree version - return -EINVAL instead of 
> -ENOENT - I have no way to guess which is right) and can carry the fix 
> as necessary (no action is required).

-EINVAL would be the better/cleaner one, so when this gets merged upstream 
we should pick up Russell's version. It does not affect functionality.

Thanks,

	Ingo
