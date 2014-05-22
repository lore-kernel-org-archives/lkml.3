Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaEVRXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:23:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:27161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaEVRXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="545048277"
Subject: Re: [PATCH 0/3] Shrinkers and proportional reclaim
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1400749779-24879-1-git-send-email-mgorman@suse.de>
References: <1400749779-24879-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 May 2014 10:22:42 -0700
Message-ID: <1400779362.2970.322.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 10:09 +0100, Mel Gorman wrote:
> This series is aimed at regressions noticed during reclaim activity. The
> first two patches are shrinker patches that were posted ages ago but never
> merged for reasons that are unclear to me. I'm posting them again to see if
> there was a reason they were dropped or if they just got lost. Dave?  Time?

As far as I remembered, I think Dave was planning to merge this as part
of his VFS scalability patch series.  Otherwise there wasn't any other
issues.

Thanks to Mel for looking at these patches and Yunhan for testing them.

Tim

