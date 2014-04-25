Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaDYJFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:05:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbaDYJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:05:51 -0400
Date: Fri, 25 Apr 2014 10:05:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/3] sched,numa: retry placement more frequently when
 misplaced
Message-ID: <20140425090548.GB23991@suse.de>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
 <1397235629-16328-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1397235629-16328-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:00:28PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> When tasks have not converged on their preferred nodes yet, we want
> to retry fairly often, to make sure we do not migrate a task's memory
> to an undesirable location, only to have to move it again later.
> 
> This patch reduces the interval at which migration is retried,
> when the task's numa_scan_period is small.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Tested-by: Vinod Chegu <chegu_vinod@hp.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
