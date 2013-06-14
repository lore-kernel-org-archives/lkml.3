Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3FNOUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:20:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:65522 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3FNOUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,866,1363158000"; 
   d="scan'208";a="353473935"
Message-ID: <51BB26B5.5000102@intel.com>
Date: Fri, 14 Jun 2013 22:20:37 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 0/4] change 64 bit variables to long type
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 03:29 PM, Alex Shi wrote:
> There are some 64 bits variables in cfs_rq/tg etc. That ask expersive
> operations in 32 bit machine. But in fact, long type is enough for them.
> 
> So do this change lead more efficient code and without data lose.
> 

some variable like cfs_rq->runnable_load_avg, there is no much changes
in patch  1/4, since in most of place it was treated as a 'unsigned
long', not u64.

Anyway, Paul, I know you are watching the mailing list. :)
Could you like to give some comments on this patchset?
> Regards
> Alex
> 


-- 
Thanks
    Alex
