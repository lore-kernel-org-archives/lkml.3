Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3FQBCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 21:02:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:25139 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab3FQBCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 21:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,877,1363158000"; 
   d="scan'208";a="354606516"
Message-ID: <51BE6003.6010507@intel.com>
Date: Mon, 17 Jun 2013 09:01:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        pjt@google.com
CC: tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 0/4] change 64 bit variables to long type
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <51BB26B5.5000102@intel.com>
In-Reply-To: <51BB26B5.5000102@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:20 PM, Alex Shi wrote:
> On 06/07/2013 03:29 PM, Alex Shi wrote:
>> There are some 64 bits variables in cfs_rq/tg etc. That ask expensive
>> operations in 32 bit machine. But in fact, long type is enough for them.
>>
>> So do this change lead more efficient code and without data lose.
>>
> 
> some variable like cfs_rq->runnable_load_avg, there is no much changes
> in patch 1/4, since in most of place it was treated as a 'unsigned
> long', not u64.
> 

The patchset change some u64 load avg variables to 'unsigned long' type,
because the related load variable is 'unsigned long' too.

Peter,
It looks quite straight. So if Paul is too busy to look into this,
Believe you can do decide independent.  :)

>> Regards
>> Alex
>>
> 
> 


-- 
Thanks
    Alex
