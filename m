Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaGAGKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:10:17 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40201 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAGKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:10:16 -0400
Message-ID: <53B250BD.9080808@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2014 14:10:05 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <53B11387.9020001@linux.vnet.ibm.com> <1404115601.5132.156.camel@marge.simpson.net> <53B12417.9060904@linux.vnet.ibm.com> <1404120453.5132.194.camel@marge.simpson.net> <53B223AE.10903@linux.vnet.ibm.com> <1404193267.5159.28.camel@marge.simpson.net>
In-Reply-To: <1404193267.5159.28.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070106-5490-0000-0000-000000539951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 01:41 PM, Mike Galbraith wrote:
> On Tue, 2014-07-01 at 10:57 +0800, Michael wang wrote:
> 
>> IMHO, currently the generic scheduler just try to take care both latency
>> and throughput, both will take a little damage but won't be damaged too
>> much, they just sacrificed for each other...
> 
> The cost can be large, so it's worth an occasional ponder.

Sure, if there are some useless efforts there, we'll locate them anyway,
sooner or later ;-)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

