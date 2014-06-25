Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaFYKjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:39:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbaFYKja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:39:30 -0400
Date: Wed, 25 Jun 2014 11:39:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, peterz@infradead.com,
        mingo@kernel.org
Subject: Re: [PATCH 4/7] sched,numa: simplify task_numa_compare
Message-ID: <20140625103923.GA10819@suse.de>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <1403538095-31256-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403538095-31256-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:41:32AM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> When a task is part of a numa_group, the comparison should always use
> the group weight, in order to make workloads converge.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
