Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3DBJ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:58:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39215 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3DBJ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:58:21 -0400
Message-ID: <515AA8B8.2090009@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 17:45:28 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
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
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com>
In-Reply-To: <515A9859.6000606@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13040209-7014-0000-0000-000002CC88A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:35 PM, Alex Shi wrote:
> On 04/02/2013 03:23 PM, Michael Wang wrote:
[snip]
>>
>> The reason may caused by wake_affine()'s higher overhead, and pgbench is
>> really sensitive to this stuff...
> 
> Thanks for testing. Could you like to remove the last patch and test it
> again? I want to know if the last patch has effect on pgbench.

Amazing, without the last one, pgbench show very good improvement,
higher than 10ms throttle, lower than 100ms throttle, I need confirm
this with a night-through testing.

I will look into those patches in detail later, I think it addressed
part of the wake_affine() issue (make the decision more accurately),
that's nice ;-)

Regards,
Michael Wang

> 

