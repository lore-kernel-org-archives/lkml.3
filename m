Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaAXPmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:42:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaAXPmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:42:17 -0500
Date: Fri, 24 Jan 2014 15:42:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 8/9] numa,sched: rename variables in task_numa_fault
Message-ID: <20140124154214.GB4963@suse.de>
References: <1390342811-11769-1-git-send-email-riel@redhat.com>
 <1390342811-11769-9-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390342811-11769-9-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:20:10PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> We track both the node of the memory after a NUMA fault, and the node
> of the CPU on which the fault happened. Rename the local variables in
> task_numa_fault to make things more explicit.
> 
> Suggested-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
