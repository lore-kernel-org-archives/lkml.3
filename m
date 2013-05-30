Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab3E3Ao5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 20:44:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:44821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3E3Aou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 20:44:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,767,1363158000"; 
   d="scan'208";a="345424661"
Message-ID: <51A6A0E0.5020200@intel.com>
Date: Thu, 30 May 2013 08:44:16 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, peterz@infradead.org
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>  <1368199049-2798-9-git-send-email-alex.shi@intel.com> <1369846845.6121.6.camel@j-VirtualBox>
In-Reply-To: <1369846845.6121.6.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 01:00 AM, Jason Low wrote:
> On Fri, 2013-05-10 at 23:17 +0800, Alex Shi wrote:
>> blocked_load_avg sometime is too heavy and far bigger than runnable load
>> avg. that make balance make wrong decision. So better don't consider it.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> Hi Alex,
> 
> I have been testing these patches with a Java server workload on an 8
> socket (80 core) box with Hyperthreading enabled, and I have been seeing
> good results with these patches.
> 
> When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
> improvement in performance of the workload compared to when using the
> vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
> kernel with just patches 1-7, the performance improvement of the
> workload over the vanilla 3.10-rc2 tip kernel was about 25%.
> 
> Tested-by: Jason Low <jason.low2@hp.com>
> 

That is impressive!

Thanks a lot for your testing! Just curious, what the benchmark are you
using? :)

> Thanks,
> Jason
> 


-- 
Thanks
    Alex
