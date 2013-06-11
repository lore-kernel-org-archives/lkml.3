Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FKDaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:30:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:26672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3FKDaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:30:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,841,1363158000"; 
   d="scan'208";a="347909171"
Message-ID: <51B699C2.3020601@intel.com>
Date: Tue, 11 Jun 2013 11:30:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com
CC: tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch 0/9] sched: use runnable load avg in balance
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <20130610150117.GA25238@laptop.programming.kicks-ass.net>
In-Reply-To: <20130610150117.GA25238@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 11:01 PM, Peter Zijlstra wrote:
> On Fri, Jun 07, 2013 at 03:20:43PM +0800, Alex Shi wrote:
>> Peter&Ingo:
> 
> I'm tempted to apply 1-7; although I want to look them over in detail
> once more; unfortunately (for you) I'm on PTO this week so it'll have to
> be early next week.

I am very happy to know you like them! :)

BTW, I am sorry for that previous version patch 7th, 'add div64_ul' was
added into mm-tree few hours ago.

> 
> As to patch 8, I really need/want buy-in from Paul on that; it removes
> the entire point of the blocked load stuff.

'remove blocked_load_avg' should be 9th patch now. Yes, I also am
waiting for Paul's comments.


Wish you all best!
-- 
Thanks
    Alex
