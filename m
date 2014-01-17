Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaAQB7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:59:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaAQB7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:59:42 -0500
Message-ID: <52D88E66.40801@redhat.com>
Date: Thu, 16 Jan 2014 20:59:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] sched/numa: document CLONE_VM behavior
References: <1389812509.4971.34.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1389812509.4971.34.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 02:01 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> The changelog for Rik's "sched/numa: Stay on the same node if CLONE_VM" patch
> serves well documented in the code.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
