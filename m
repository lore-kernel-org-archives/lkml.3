Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3EaIYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:24:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:11805 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3EaIYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:24:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,777,1363158000"; 
   d="scan'208";a="346077875"
Message-ID: <51A85E0A.5070806@intel.com>
Date: Fri, 31 May 2013 16:23:38 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: peterz@infradead.org, mingo@kernel.org, preeti@linux.vnet.ibm.com,
        vincent.guittot@linaro.org, efault@gmx.de, pjt@google.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arjan@linux.intel.com, len.brown@intel.com, corbet@lwn.net,
        tglx@linutronix.de
Subject: Re: [RFC] Comparison of power-efficient scheduling patch sets
References: <20130530134718.GB32728@e103034-lin> <51A7FA14.70902@intel.com>
In-Reply-To: <51A7FA14.70902@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 09:17 AM, Alex Shi wrote:
>> > Kernel: 3.9
>> > 
>> > Patch sets:
>> > rlb-v4: sched: use runnable load based balance (Alex Shi)
>> >         <https://lkml.org/lkml/2013/4/27/13>
> Thanks for the valuable comparison!
> 
> The runnable load balance target is performance. It is still try to
> disperse tasks to as much as possible CPUs. :)
> The latest v7 version remove the 6th patch(wake_affine change) in v4.
> and plus fix a slept time double counting issue, and remove
> blocked_load_avg in tg load.
> http://comments.gmane.org/gmane.linux.kernel/1498988

Even the rlb patch set target is performance, Maybe the power benefit is
due to better balancing?

Anyway I appreciate if you like to test the latest v7 version. :)
https://github.com/alexshi/power-scheduling.git runnablelb

-- 
Thanks
    Alex
