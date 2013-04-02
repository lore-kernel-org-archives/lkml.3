Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323Ab3DBJNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:13:46 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:46315 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3DBJNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:13:45 -0400
Message-ID: <515AA13A.5090709@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 17:13:30 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <1364891674.4976.65.camel@marge.simpson.net>
In-Reply-To: <1364891674.4976.65.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040209-8256-0000-0000-000006E59CFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:34 PM, Mike Galbraith wrote:
[snip]
>> The reason may caused by wake_affine()'s higher overhead, and pgbench is
>> really sensitive to this stuff...
> 
> For grins, you could try running the whole thing SCHED_BATCH.  (/me sees
> singing/dancing red herring whenever wake_affine() and pgbench appear in
> the same sentence;)

I saw the patch touched the wake_affine(), just interested on what will
happen ;-)

The patch changed the overhead of wake_affine(), and also influence it's
result, I used to think the later one may do some help to the pgbench...

Regards,
Michael Wang

> 
> -Mike
> 

