Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3BUTby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:31:54 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50700 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3BUTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:31:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="26347418"
Message-ID: <51267626.3030308@codeaurora.org>
Date: Thu, 21 Feb 2013 11:31:50 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2013-02-19-17-20 uploaded
References: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com> <5125E809.4060407@codeaurora.org> <20130221181811.GA27097@gulag1.americas.sgi.com> <51266721.5060006@codeaurora.org> <512668FA.5040505@sgi.com>
In-Reply-To: <512668FA.5040505@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/2013 10:35 AM, Nathan Zimmer wrote:
>
>> This comment is useful around the cpumask functions.
>>
>>      Returns >= nr_cpu_ids if no further cpus set.
>>
> I had assumed it would be = nr_cpu_ids.
> I will need to rethink the iterator.

Yes it is actually equal to the nr_cpu_ids in my error case. On my
system, nr_cpu_ids = 4 and I only have one cpu online.

>
>
> Also I retested my other patches in the series, the ones for schedstat
> and sched_debug, and those worked fine.

I haven't tried those yet. I will try to take a look.

Also, can't we simplify the code by calling cpumask_next() with the
first argument being -1? No more cpu > 0 check?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

