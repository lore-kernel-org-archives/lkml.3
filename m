Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaA0VEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:04:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbaA0VEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:04:39 -0500
Date: Mon, 27 Jan 2014 16:04:23 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1390856663-xenxk2ck-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1390794746-16755-8-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
 <1390794746-16755-8-git-send-email-davidlohr@hp.com>
Subject: Re: [PATCH 7/8] mm, hugetlb: mm, hugetlb: unify chg and avoid_reserve
 to use_reserve
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1390794746-16755-8-git-send-email-davidlohr@hp.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 07:52:25PM -0800, Davidlohr Bueso wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, we have two variable to represent whether we can use reserved
> page or not, chg and avoid_reserve, respectively. With aggregating these,
> we can have more clean code. This makes no functional difference.
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
