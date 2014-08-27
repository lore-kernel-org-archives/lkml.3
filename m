Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935636AbaH0SWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:22:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34689 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaH0SWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:22:40 -0400
Message-ID: <53FE21A8.4000908@oracle.com>
Date: Wed, 27 Aug 2014 14:21:28 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de>
In-Reply-To: <20140827152622.GC12424@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 11:26 AM, Mel Gorman wrote:
> Sasha, how long does it typically take to trigger this? Are you
> using any particular switches for trinity that would trigger the bug
> faster?

It took couple of weeks (I've been running with it since the beginning
of August). I don't have any special trinity options, just the default
fuzzing. Do you think that focusing on any of the mm syscalls would
increase the odds of hitting it?

There's always the chance that this is a fluke due to corruption somewhere
else. I'll keep running it with the new debug patch and if it won't reproduce
any time soon we can probably safely assume that.


Thanks,
Sasha
