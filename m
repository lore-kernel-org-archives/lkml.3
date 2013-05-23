Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3EWNjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:39:05 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39866 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab3EWNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:39:02 -0400
MIME-Version: 1.0
In-Reply-To: <1369203761-12649-6-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
	<1369203761-12649-6-git-send-email-khandual@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 15:39:01 +0200
Message-ID: <CABPqkBSiqn+xOc80wLjibJ0Y2F9hJZbj+H=_3cJr=_Q4ZkHejg@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf, documentation: Description for conditional
 branch filter
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 8:22 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> Adding documentation support for conditional branch filter.
>
Reviewed-by: Stephane Eranian <eranian@google.com>

> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  tools/perf/Documentation/perf-record.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index d4da111..8b5e1ed 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -169,12 +169,13 @@ following filters are defined:
>          - any_call: any function call or system call
>          - any_ret: any function return or system call return
>          - ind_call: any indirect branch
> +        - cond: conditional branches
>          - u:  only when the branch target is at the user level
>          - k: only when the branch target is in the kernel
>          - hv: only when the target is at the hypervisor level
>
>  +
> -The option requires at least one branch type among any, any_call, any_ret, ind_call.
> +The option requires at least one branch type among any, any_call, any_ret, ind_call, cond.
>  The privilege levels may be omitted, in which case, the privilege levels of the associated
>  event are applied to the branch filter. Both kernel (k) and hypervisor (hv) privilege
>  levels are subject to permissions.  When sampling on multiple events, branch stack sampling
> --
> 1.7.11.7
>
