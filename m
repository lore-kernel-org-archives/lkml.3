Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3IPQhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:37:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55592 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3IPQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:37:13 -0400
Date: Mon, 16 Sep 2013 18:37:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/50] mm: Account for a THP NUMA hinting update as one
 PTE update
Message-ID: <20130916163702.GG9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-8-git-send-email-mgorman@suse.de>
 <20130916123645.GD9326@twins.programming.kicks-ass.net>
 <52370A2F.90006@redhat.com>
 <20130916145438.GT21832@twins.programming.kicks-ass.net>
 <20130916161150.GF22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916161150.GF22421@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 05:11:50PM +0100, Mel Gorman wrote:
> > I never said the change didn't make sense as such. Just that we're no
> > longer counting pages in change_*_range().
> 
> well, it's still a THP page. Is it worth renaming?

Dunno, the pedant in me needed to raise the issue :-)
