Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbaLKWWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:22:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbaLKWWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:22:02 -0500
Date: Thu, 11 Dec 2014 23:21:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, namhyung@kernel.org
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20141211222145.GE26788@krava.redhat.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:06:51AM -0500, kan.liang@intel.com wrote:

SNIP

> 
> Please find the kernel part patch at https://lkml.org/lkml/2014/11/6/432
> 
> Changes since v1
>  - Update help document
>  - Force exclude_user to 0 with warning in LBR call stack
>  - Dump both lbr and fp info when report -D
>  - Reconstruct thread__resolve_callchain_sample and split it into two patches
>  - Use has_branch_callstack function to check LBR call stack available
> 
> Changes since v2
>  - Rebase to 025ce5d33373
> 
> Changes since v3
>  - Rebase to cc502c23aadf
>  - Separated function for lbr call stack sample resolve and print
>  - Some minor changes according to comments
> 
> Changes since V4
>  - Rebase to 09a6a1b
>  - Falling back to framepointers if LBR not available, and warning user
> 
> Kan Liang (3):
>   perf tools: enable LBR call stack support
>   perf tool: Move cpumode resolve code to add_callchain_ip
>   perf tools: Construct LBR call chain

haven't reviewed the kernel part, but the user part
seems to work properly..

Tested-by: Jiri Olsa <jolsa@kernel.org>

jirka
