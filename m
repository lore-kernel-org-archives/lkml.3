Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab3E1G3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:29:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64273 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3E1G3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:29:19 -0400
Date: Tue, 28 May 2013 08:29:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Basic perf PMU support for Haswell v12
Message-ID: <20130528062915.GA26467@gmail.com>
References: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> All outstanding issues fixed I hope. And I added mem-loads/stores support.
> 
> Contains support for:
> - Basic Haswell PMU and PEBS support
> - Late unmasking of the PMI
> - mem-loads/stores support
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
> v10: Change some whitespace. Rebase to 3.9rc3
> v11: Rebase to perf/core. Fix extra regs. Rename INTX.
> v12: Rebase to 3.10-rc2
> Add mem-loads/stores support for parity with Sandy Bridge.
> Fix fixed counters (Thanks Ingo!)
> Make late ack optional
> Export new config bits in sysfs.
> Minor changes

I reported a pretty nasty regression with the previous version (v10) which 
made this series break default 'perf top' on non-Haswell systems - but 
it's unclear from this changelog to what extent you managed to reproduce 
the bug and fix it, and what the fix was?

If it's fixed then please don't hide fixes - you need to follow up in the 
original threads where they got reported, not just some obscure changelog 
entry in the next version post ...

I'd really like to make progress with this feature - 11 iterations is 
ridiculous really.

Thanks,

	Ingo
