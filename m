Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3C1PNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:13:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65443 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3C1PNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
Date: Thu, 28 Mar 2013 16:13:04 +0100
Message-ID: <CABPqkBTvzFesn+q576YaQudNYWmdyQZaDUd1+1aYjDhXNyB4ng@mail.gmail.com>
Subject: Re: Basic perf PMU support for Haswell v10
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 8:59 PM, Andi Kleen <andi@firstfloor.org> wrote:
> This is based on v7 of the full Haswell PMU support,
> rebased, and stripped down to the bare bones
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
> v10: Change some whitespace. Rebase to 3.9rc3
>
I have not seen any movement on this series.
What's wrong with it this time?
