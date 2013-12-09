Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab3LIIrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:47:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760702Ab3LIIrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:47:04 -0500
Date: Mon, 9 Dec 2013 08:46:59 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/18] mm: numa: Make NUMA-migrate related functions
 static
Message-ID: <20131209084659.GX11295@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
 <1386572952-1191-14-git-send-email-mgorman@suse.de>
 <20131209072010.GA3716@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131209072010.GA3716@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 03:20:10PM +0800, Wanpeng Li wrote:
> Hi Mel,
> On Mon, Dec 09, 2013 at 07:09:07AM +0000, Mel Gorman wrote:
> >numamigrate_update_ratelimit and numamigrate_isolate_page only have callers
> >in mm/migrate.c. This patch makes them static.
> >
> 
> I have already send out patches to fix this issue yesterday. ;-)
> 
> http://marc.info/?l=linux-mm&m=138648332222847&w=2
> http://marc.info/?l=linux-mm&m=138648332422848&w=2
> 

I know. I had written the patch some time ago waiting to go out with
the TLB flush fix and just didn't bother dropping it in response to your
series.

-- 
Mel Gorman
SUSE Labs
