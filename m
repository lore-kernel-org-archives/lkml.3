Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965763Ab3HIJha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:37:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47565 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965382Ab3HIJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:37:27 -0400
X-AuditID: 9c930197-b7b44ae00000347f-74-5204b854b128
Date: Fri, 9 Aug 2013 18:37:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 17/18] mm, hugetlb: retry if we fail to allocate a
 hugepage with use_reserve
Message-ID: <20130809093724.GA11091@lge.com>
References: <1375075929-6119-18-git-send-email-iamjoonsoo.kim@lge.com>
 <20130729072823.GD29970@voom.fritz.box>
 <20130731053753.GM2548@lge.com>
 <20130803104302.GC19115@voom.redhat.com>
 <20130805073647.GD27240@lge.com>
 <1375834724.2134.49.camel@buesod1.americas.hpqcorp.net>
 <20130807010312.GA17110@voom.redhat.com>
 <1375839529.2134.50.camel@buesod1.americas.hpqcorp.net>
 <20130807091832.GD32449@lge.com>
 <20130809000231.GB2904@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809000231.GB2904@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I once attempted an approach involving an atomic counter of the number
> of "in flight" hugepages, only retrying when it's non zero.  Working
> out a safe ordering for all the updates to get all the cases right
> made my brain melt though, and I never got it working.

I sent v2 few seconds before. My new approach is similar as yours.
Could you review my patches to save my brain to be melted? :)

Thanks.

