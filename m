Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaETNEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:04:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26671 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:04:29 -0400
Message-ID: <537B52BD.1080807@oracle.com>
Date: Tue, 20 May 2014 09:03:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
References: <5371122D.6020605@oracle.com> <537AB86B.4020901@oracle.com> <20140520110431.GX2485@laptop.programming.kicks-ass.net>
In-Reply-To: <20140520110431.GX2485@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 07:04 AM, Peter Zijlstra wrote:
> On Mon, May 19, 2014 at 10:05:31PM -0400, Sasha Levin wrote:
>> ping? It seems to be easy enough to reproduce on -next, I'd be happy to try
>> debug patches/fixes.
> 
> Does this fuzzing you do also include hotplug? If so, does disabling
> that make this problem go away?
> 

There were no hotplug operations going on when this happens, so it seems
unrelated.


Thanks,
Sasha
