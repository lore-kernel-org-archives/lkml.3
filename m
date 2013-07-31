Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693Ab3GaUqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab3GaUqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:46:47 -0400
Date: Wed, 31 Jul 2013 16:46:21 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Hillf Danton <dhillf@gmail.com>
Message-ID: <1375303581-l14hjkth-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130731050824.GJ2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-12-git-send-email-iamjoonsoo.kim@lge.com>
 <1375123170-v27s5zvu-mutt-n-horiguchi@ah.jp.nec.com>
 <20130731050824.GJ2548@lge.com>
Subject: Re: [PATCH 11/18] mm, hugetlb: move down outside_reserve check
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130731050824.GJ2548@lge.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:08:24PM +0900, Joonsoo Kim wrote:
> On Mon, Jul 29, 2013 at 02:39:30PM -0400, Naoya Horiguchi wrote:
> > On Mon, Jul 29, 2013 at 02:32:02PM +0900, Joonsoo Kim wrote:
> > > Just move down outsider_reserve check.
> > > This makes code more readable.
> > > 
> > > There is no functional change.
> > 
> > Why don't you do this in 10/18?
> 
> Just help to review :)
> Step-by-step approach may help to review, so I decide to be separate it.
> If you don't want it, I will merge it in next spin.

OK, it's up to you actually.
