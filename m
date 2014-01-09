Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaAITsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:48:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbaAITsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:48:42 -0500
Message-ID: <52CEFCB9.2030604@redhat.com>
Date: Thu, 09 Jan 2014 14:47:05 -0500
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
Subject: Re: [PATCH 2/5] x86: mm: Clean up inconsistencies when flushing TLB
 ranges
References: <1389278098-27154-1-git-send-email-mgorman@suse.de> <1389278098-27154-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1389278098-27154-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 09:34 AM, Mel Gorman wrote:
> NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and the
> comparison with total_vm is done before taking tlb_flushall_shift into
> account. Clean it up.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Alex Shi <alex.shi@linaro.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

