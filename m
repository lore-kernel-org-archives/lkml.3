Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaAUQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:15:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbaAUQPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:15:22 -0500
Date: Tue, 21 Jan 2014 16:15:18 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 6/6] numa,sched: do statistics calculation using local
 variables only
Message-ID: <20140121161518.GM4963@suse.de>
References: <1390245667-24193-1-git-send-email-riel@redhat.com>
 <1390245667-24193-7-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390245667-24193-7-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 02:21:07PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> The current code in task_numa_placement calculates the difference
> between the old and the new value, but also temporarily stores half
> of the old value in the per-process variables.
> 
> The NUMA balancing code looks at those per-process variables, and
> having other tasks temporarily see halved statistics could lead to
> unwanted numa migrations. This can be avoided by doing all the math
> in local variables.
> 
> This change also simplifies the code a little.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
