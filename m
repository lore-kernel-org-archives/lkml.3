Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaAIUBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:01:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbaAIUBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:01:07 -0500
Message-ID: <52CEFF97.6000709@redhat.com>
Date: Thu, 09 Jan 2014 14:59:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Alex Shi <alex.shi@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1389278098-27154-1-git-send-email-mgorman@suse.de> <1389278098-27154-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1389278098-27154-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 09:34 AM, Mel Gorman wrote:
> There was a large performance regression that was bisected to commit 611ae8e3
> (x86/tlb: enable tlb flush range support for x86). This patch simply changes
> the default balance point between a local and global flush for IvyBridge.
>
> In the interest of allowing the tests to be reproduced, this patch was
> tested using mmtests 0.15 with the following configurations
>
> 	configs/config-global-dhp__tlbflush-performance
> 	configs/config-global-dhp__scheduler-performance
> 	configs/config-global-dhp__network-performance


> Based on these results, changing the default for Ivybridge seems
> like a logical choice.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Alex Shi <alex.shi@linaro.org>

Reviewed-by: Rik van Riel <riel@redhat.com>
