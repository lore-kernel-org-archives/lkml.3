Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab3GPA0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:26:54 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43323 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GPA0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:26:52 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-06-51e4934afcde
Date: Tue, 16 Jul 2013 09:26:52 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages allocation
Message-ID: <20130716002652.GA2430@lge.com>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com>
 <51DDE5BA.9020800@intel.com>
 <20130711010248.GB7756@lge.com>
 <51DE44CC.2070700@sr71.net>
 <20130711061201.GA2400@lge.com>
 <51DED47A.8090008@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DED47A.8090008@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 08:51:22AM -0700, Dave Hansen wrote:
> On 07/10/2013 11:12 PM, Joonsoo Kim wrote:
> >> > I'd also like to see some scalability numbers on this.  How do your
> >> > tests look when all the CPUs on the system are hammering away?
> > What test do you mean?
> > Please elaborate on this more
> 
> Your existing tests looked single-threaded.  That's certainly part of
> the problem.  Will your patches have implications for larger systems,
> though?  How much do your patches speed up or slow things down if we
> have many allocations proceeding on many CPUs in parallel?

Hello.

Okay, I will do that and attach the result to v2.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
