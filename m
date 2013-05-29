Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052Ab3E2N2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:28:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:62826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab3E2N2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:28:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="341956011"
Message-ID: <51A60263.4020404@intel.com>
Date: Wed, 29 May 2013 21:28:03 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, pjt@google.com
CC: tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <51948AD4.3020104@linux.vnet.ibm.com> <51A4B19A.5090500@intel.com>
In-Reply-To: <51A4B19A.5090500@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 09:31 PM, Alex Shi wrote:
>> > Tested the latest patch set (new 3/8 and 6/8) with pgbench, tip
>> > 3.10.0-rc1 and 12 cpu X86 box, works well and still benefit ;-)
> 
> Paul:
> 
> Would you like to give more comments/ideas of this patch set?

Peter,

If no more idea of the blocked_load_avg usages, could we have the
patchset clobbered in tip tree? Any way we get better performance on
hackbench/pgbench/cgroup stress etc benchmarks.

-- 
Thanks
    Alex
