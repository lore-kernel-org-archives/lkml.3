Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab3DCLRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:17:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:62646 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab3DCLRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,401,1363158000"; 
   d="scan'208";a="280145960"
Message-ID: <515C0FBA.2070004@intel.com>
Date: Wed, 03 Apr 2013 19:17:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515BEC5F.60001@intel.com> <515BF847.1000808@linux.vnet.ibm.com>
In-Reply-To: <515BF847.1000808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 05:37 PM, Michael Wang wrote:
>> > 
>> > Michael:
>> > I changed the threshold to 0.1ms it has same effect on aim7.
>> > So could you try the following on pgbench?
> Hi, Alex
> 
> I've done some rough test and the change point should in 60000~120000,

Sounds good.
> I'm currently running a auto test with value 500000, 250000, 120000,
> 60000, 30000, 15000, 6000, 3000, 1500, it will take some time to finish
> the test, and we will gain detail info for analysis.

Thanks
> 
> BTW, you know we have festival in China, so the report may be delayed,
> forgive me on that ;-)

That's all right. I locate in China too. :)

-- 
Thanks
    Alex
