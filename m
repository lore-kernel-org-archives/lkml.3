Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709Ab3FSMs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:48:28 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37787 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab3FSMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:48:27 -0400
Date: Wed, 19 Jun 2013 14:48:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: Basic perf PMU support for Haswell v14
Message-ID: <20130619124822.GC11209@gmail.com>
References: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371515812-9646-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

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
> v13:
> Various white space changes.
> v14:
> Rebased to 3.10-rc6

Ok, this series looks good at first sight: you've slightly overdone the 
checkpatch style changes without checking that the result is actually an 
improvement - I've fixed those few places.

I'll give it a bit of testing.

Thanks,

	Ingo
