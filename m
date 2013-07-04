Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3GDOZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:25:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3GDOZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:25:09 -0400
Message-ID: <51D585A8.3070001@redhat.com>
Date: Thu, 04 Jul 2013 10:24:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] sched: Split accounting of NUMA hinting faults
 that pass two-stage filter
References: <1372861300-9973-1-git-send-email-mgorman@suse.de> <1372861300-9973-8-git-send-email-mgorman@suse.de> <20130703215654.GN17812@cmpxchg.org> <20130704092356.GK1875@suse.de>
In-Reply-To: <20130704092356.GK1875@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:23 AM, Mel Gorman wrote:

> I think that dealing with this specific problem is a series all on its
> own and treating it on its own in isolation would be best.

Agreed, lets tackle one thing at a time, otherwise we will
(once again) end up with a patch series that is too large
to merge.

-- 
All rights reversed
