Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3FJCUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:20:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:14575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3FJCUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,833,1363158000"; 
   d="scan'208";a="314572961"
Message-ID: <51B537E8.6010809@intel.com>
Date: Mon, 10 Jun 2013 10:20:24 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org
CC: tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>
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

BTW, this patch bases on my v8 patchset: use runnable load in balance.
the git tree is here:
git@github.com:alexshi/power-scheduling.git runnablelb


Any more comments?

> 
> Regards
> Alex
> 


-- 
Thanks
    Alex
