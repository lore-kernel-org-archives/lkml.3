Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaENDXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:23:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:5604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaENDXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:23:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1049,1389772800"; 
   d="scan'208";a="539997371"
From: Andi Kleen <andi@firstfloor.org>
To: "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Peter Oberparleiter'" <oberpar@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] gcov: add support for GCC 4.9
References: <000501cf6f08$7735a6a0$65a0f3e0$@sei.pku.edu.cn>
Date: Tue, 13 May 2014 20:23:36 -0700
In-Reply-To: <000501cf6f08$7735a6a0$65a0f3e0$@sei.pku.edu.cn> (Yuan Pengfei's
	message of "Wed, 14 May 2014 08:07:16 +0800")
Message-ID: <87lhu53ux3.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yuan Pengfei" <yuanpf12@sei.pku.edu.cn> writes:

> This patch handles the gcov-related changes in GCC 4.9:
>   A new counter (time profile) is added. The total number is 9 now.
>   A new profile merge function __gcov_merge_time_profile is added.
> See gcc/gcov-io.h and libgcc/libgcov-merge.c
> For the first change, the layout of struct gcov_info is affected.
> For the second one, a dummy function is added to kernel/gcov/base.c
> similarly.


Thanks for doing that. I tried it too at some point, but failed.
>  
> +void __gcov_merge_time_profile(gcov_type *counters, unsigned int
> n_counters)

But can you repost please without word wrapping?

Except for that the patch looks good to me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
