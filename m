Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbaAGCiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:38:01 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:39551 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbaAGCiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:38:00 -0500
Message-ID: <1389062271.9937.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 01/14] mm, hugetlb: unify region structure handling
From: Davidlohr Bueso <davidlohr@hp.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Date: Mon, 06 Jan 2014 18:37:51 -0800
In-Reply-To: <1387349640-8071-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1387349640-8071-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 15:53 +0900, Joonsoo Kim wrote:
> Currently, to track a reserved and allocated region, we use two different
> ways for MAP_SHARED and MAP_PRIVATE. For MAP_SHARED, we use
> address_mapping's private_list and, for MAP_PRIVATE, we use a resv_map.
> Now, we are preparing to change a coarse grained lock which protect
> a region structure to fine grained lock, and this difference hinder it.
> So, before changing it, unify region structure handling.
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

