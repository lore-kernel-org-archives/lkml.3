Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab3BMPP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:15:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:51883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab3BMPP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:15:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="285223372"
Message-ID: <511BADE3.4050009@intel.com>
Date: Wed, 13 Feb 2013 23:14:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop>
In-Reply-To: <1360664784.4485.17.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:26 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> +       /*
>> +        * set the initial load avg of new task same as its load
>> +        * in order to avoid brust fork make few cpu too heavier
>> +        */
>> +       if (flags & ENQUEUE_NEWTASK)
>> +               se->avg.load_avg_contrib = se->load.weight; 
> 
> I seem to have vague recollections of a discussion with pjt where we
> talk about the initial behaviour of tasks; from this haze I had the
> impression that new tasks should behave like full weight..
> 

Here just make the new task has full weight..

> PJT is something more fundamental screwy?
> 


-- 
Thanks
    Alex
