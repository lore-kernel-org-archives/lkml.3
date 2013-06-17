Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3FQJ7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:59:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:26741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab3FQJ7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,880,1363158000"; 
   d="scan'208";a="354636524"
Message-ID: <51BEDDD8.4050900@intel.com>
Date: Mon, 17 Jun 2013 17:58:48 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-2-git-send-email-alex.shi@intel.com> <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com> <51B2948A.60309@intel.com> <CAKfTPtBuMsQtHds0sWvgfpV1nkr76_mOn83jZDk9216vX3F+Ow@mail.gmail.com>
In-Reply-To: <CAKfTPtBuMsQtHds0sWvgfpV1nkr76_mOn83jZDk9216vX3F+Ow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 05:54 PM, Vincent Guittot wrote:
>> > So, usually the limited task number in Linux is often far lower this
>> > number: $ulimit -u.
>> >
>> > Anyway, at least, the runnable_load_avg is smaller then load.weight. if
>> > load.weight can use long type, runablle_load_avg is no reason can't.
> Alex,
> 
> You can add my tested-by for this patchset.

thanks for test!

-- 
Thanks
    Alex
