Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936559Ab3DJNMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:12:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:33530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935841Ab3DJNM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="320291819"
Message-ID: <51656534.6030902@intel.com>
Date: Wed, 10 Apr 2013 21:12:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, peterz@infradead.org
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <5163A25F.5080909@intel.com>
In-Reply-To: <5163A25F.5080909@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 01:08 PM, Alex Shi wrote:
> On 04/02/2013 11:23 AM, Alex Shi wrote:
>> > This version resolved the aim7 liked benchmark issue by patch 8th.
>> > Thanks for MikeG's avg_idle that is a good bursty wakeup indicator.
>> > 
>> > The first 3 patches were also include in my power aware scheduling patchset.
>> > 
>> > Morten, you can rebase your patch on this new version that bases on latest
>> > Linus tree. :)
>> > 
>> > a git tree for this patchset:
>> > 	https://github.com/alexshi/power-scheduling.git runnablelb
> I removed the 3rd and 8th patches, left 1,2,4,5,6,7. and updated them in
> above git tree.
> 
> I tested the kbuild, specjbb2005, aim9, fileio-cfq, hackbench and
> dbench. on my NHM EP and 2 sockets SNB EP box. hackbench increased 3~5%
> on both machines. kbuild has suspicious 2% increase. others has no clear
> change.

This patchset has tested by ARM guys and Michael. None of regression found.

Peter, could you like to give some comments?

-- 
Thanks
    Alex
