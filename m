Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3GWHbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:31:17 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57377 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab3GWHbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:31:15 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-38-51ee3141f952
Date: Tue, 23 Jul 2013 16:31:17 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] mm, hugetlb: clean-up and possible bug fix
Message-ID: <20130723073117.GC2266@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
 <87txjmmw39.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txjmmw39.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 09:21:38PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > First 6 patches are almost trivial clean-up patches.
> >
> > The others are for fixing three bugs.
> > Perhaps, these problems are minor, because this codes are used
> > for a long time, and there is no bug reporting for these problems.
> >
> > These patches are based on v3.10.0 and
> > passed the libhugetlbfs test suite.
> 
> Please also add the new tests you have as part of this patch series to
> the test suite.

Okay.

Thanks for reviewing this patchset.

> 
> -aneesh
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
