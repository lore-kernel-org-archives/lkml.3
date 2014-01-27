Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaA0VCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:02:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaA0VCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:02:52 -0500
Date: Mon, 27 Jan 2014 16:02:19 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1390856539-4i40zgqy-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1390794746-16755-2-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
 <1390794746-16755-2-git-send-email-davidlohr@hp.com>
Subject: Re: [PATCH 1/8] mm, hugetlb: unify region structure handling
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1390794746-16755-2-git-send-email-davidlohr@hp.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 07:52:19PM -0800, Davidlohr Bueso wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, to track reserved and allocated regions, we use two different
> ways, depending on the mapping. For MAP_SHARED, we use address_mapping's
> private_list and, while for MAP_PRIVATE, we use a resv_map.
> 
> Now, we are preparing to change a coarse grained lock which protect a
> region structure to fine grained lock, and this difference hinder it.
> So, before changing it, unify region structure handling, consistently
> using a resv_map regardless of the kind of mapping.
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> [Updated changelog]
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
