Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3GCQTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:19:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776Ab3GCQTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:19:19 -0400
Date: Wed, 3 Jul 2013 17:19:15 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/13] Basic scheduler support for automatic NUMA
 balancing V2
Message-ID: <20130703161915.GJ1875@suse.de>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1372861300-9973-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:21:27PM +0100, Mel Gorman wrote:
> o 3.9.0-vanilla		vanilla kernel with automatic numa balancing enabled
> o 3.9.0-morefaults	Patches 1-9
> o 3.9.0-scalescan	Patches 1-10
> o 3.9.0-scanshared	Patches 1-12
> o 3.9.0-accountpreferred Patches 1-13
> 

I screwed up the testing as 3.9.0-morefaults is not patches 1-9 at all and
I only noticed when examining an anomaly. It's a unreleased series that
I screwed up the patch generation for. The conclusions about patches 1-9
are invalid. I'll redo the testing.

-- 
Mel Gorman
SUSE Labs
