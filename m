Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaHKFqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:46:30 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:49700 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaHKFq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:46:29 -0400
Date: Mon, 11 Aug 2014 07:46:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v3 00/23] perf: Add infrastructure and support for Intel
 PT
Message-ID: <20140811054625.GC7489@gmail.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:

> Hi Peter and all,
> 
> Here's a new version of PT support patchset, this time including PT and
> BTS drivers and a few more tweaks to the core. I still left out some bits
> like core dump support for now. Tooling support is not included in this
> series so that it's easier to review the kernel bits, I suppose it's best
> to send it separately, since it's quite a huge patchset of its own.

I know what this series is about, but pretty please, always include a 
complete introduction, or at least a link to a good introdcution, 
which spells out the whole problem space, the proposed solution, its 
various design trade-offs (if any), links to tooling for people who 
want to have a look at both sides, list of items not yet properly 
implemented [or a clear statement that it's all ready to go in your 
view], etc., in as much detail as possible!

The reason is that many reviewers will skip early versions of patch 
series, especially if they see something trivially objectionable in 
it. Why spend effort on reviewing something that might never see the 
light of the day? But if later re-sends of the series skip essential 
information it's harder to 'jump in' and offer useful feedback...

If you worry about being overly verbose in your patch series 
announcement, in my experience as a kernel maintainer it's literally 
impossible for kernel developers to over-do the description of a new 
feature. (Steve Rostedt tries on occasion but even he never succeeded 
in the past. I claim this is due to software developer brain 
structure, but I digress.)

It's also absolutely fine to cut & paste an old 0/N description over 
and over again, and to update it only as far as the patches have 
changed.

A good rule of thumb is to have at least as many sentences in the 0/N 
description as there are patches in the series, i.e. 23 sentences in 
this instance. Preferably scaled up by complexity.

Thanks,

	Ingo
