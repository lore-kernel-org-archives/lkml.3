Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaEIAIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:08:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17993 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaEIAIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:08:46 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7fd86d0000038e3-84-536c1c8c173b
Content-transfer-encoding: 8BIT
Message-id: <1399593989.13268.59.camel@kjgkr>
Subject: Re: [BUG] kmemleak on __radix_tree_preload
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Fri, 09 May 2014 09:06:29 +0900
In-reply-to: <20140508165217.GI17344@arm.com>
References: <20140501184112.GH23420@cmpxchg.org>
 <1399431488.13268.29.camel@kjgkr> <20140507113928.GB17253@arm.com>
 <1399540611.13268.45.camel@kjgkr> <20140508092646.GA17349@arm.com>
 <1399541860.13268.48.camel@kjgkr> <20140508102436.GC17344@arm.com>
 <20140508150026.GA8754@linux.vnet.ibm.com> <20140508152946.GA10470@localhost>
 <20140508155330.GE8754@linux.vnet.ibm.com> <20140508165217.GI17344@arm.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ90emZxgg01zeC3eL+thtFi9ydfi
	8q45bBb31vxntXi7+TurA6vHmnlrGD0Ov3nP7LHp0yR2jweHNrN4fN4kF8AaxWWTkpqTWZZa
	pG+XwJVx9cQapoIG/oon7+awNDC+5e5i5OSQEDCR+PDoOwuELSZx4d56ti5GLg4hgWWMEm/2
	vmOGKZp8eQ0rRGIRo8Tm82cZQRK8AoISPybfA+rm4GAWkJc4cikbJMwsoC4xad4isF4hgVeM
	EjNvWkGU60q0TvsJtkxYwFhi4dQGJpBWNgFtic37DSDKFSXe7r/LCmKLAJVfaJvCArKWWeA4
	o8SeO3/ZQBIsAqoS3zufsYPYnEBF798cZYG4bS6zxPOP+8GK+AVEJQ4v3A71gJLE7vZOdpAi
	CYF77BKt/V9ZISYJSHybfAjsAQkBWYlNB6DqJSUOrrjBMoFRYhaSN2chvDkLyZsLGJlXMYqm
	FiQXFCelFxnpFSfmFpfmpesl5+duYoTEY98OxpsHrA8xJgNtnMgsJZqcD4znvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR5Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKOtUHrLU8NmK6GUt
	iQ2h1Zb2xaeSHY1StQv+xgcXBOqcfP/a6ZToz/8qGxee2r5eoD6P3dLE7NW+pEw1psldWxbk
	trt110zK/cPHfNf2V9VJYaH9rcWTjZ8nesypmP65bdoER2Otpo8OXzeIT9XxTXX/NG+/7wL7
	RBmtO/P4fC0tZ55+NXeqEktxRqKhFnNRcSIAGf5qZt0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd0emZxggzuNnBbvl/UwWqze5Gtx
	edccNot7a/6zWrzd/J3VgdVjzbw1jB6H37xn9tj0aRK7x4NDm1k8Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuHpiDVNBA3/Fk3dzWBoY33J3MXJySAiYSEy+
	vIYVwhaTuHBvPVsXIxeHkMAiRonN588ygiR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8
	RcwgtpDAK0aJmTetIMp1JVqn/WQBsYUFjCUWTm1gAmllE9CW2LzfAKJcUeLt/rtga0WAyi+0
	TWEBWcsscJxRYs+dv2wgCRYBVYnvnc/YQWxOoKL3b46yQNw2l1ni+cf9YEX8AqIShxduZ4Z4
	QElid3sn+wRGoVlIzp6FcPYsJGcvYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc7c+k
	dzCuarA4xCjAwajEw/tiSnawEGtiWXFl7iFGCQ5mJRHeF8uAQrwpiZVVqUX58UWlOanFhxiT
	gS6fyCwlmpwPTER5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cC4TaDq8qtjZ47b96wpZvd9d3/hGuZdWa/il05SvHH2qVFimH1L+usdL3OTzxoueT4t/4zd
	3HVcC/0+Hz7E8ivvo3jEzbuaoZayTtn/n9/V4osxzZrtITn7kdrx9UemCelmBNqJJCjO0Zh/
	ZOe+bun9Nn8SEzz3X8494h2dm7Pqtxbz8ROtfG9rlViKMxINtZiLihMBgTBamjoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-08 (목), 17:52 +0100, Catalin Marinas:
> On Thu, May 08, 2014 at 04:53:30PM +0100, Paul E. McKenney wrote:
> > On Thu, May 08, 2014 at 04:29:48PM +0100, Catalin Marinas wrote:
> > > BTW, is it safe to have a union overlapping node->parent and
> > > node->rcu_head.next? I'm still staring at the radix-tree code but a
> > > scenario I have in mind is that call_rcu() has been raised for a few
> > > nodes, other CPU may have some reference to one of them and set
> > > node->parent to NULL (e.g. concurrent calls to radix_tree_shrink()),
> > > breaking the RCU linking. I can't confirm this theory yet ;)
> > 
> > If this were reproducible, I would suggest retrying with non-overlapping
> > node->parent and node->rcu_head.next, but you knew that already.  ;-)
> 
> Reading the code, I'm less convinced about this scenario (though it's
> worth checking without the union).
> 
> > But the usual practice would be to make node removal exclude shrinking.
> > And the radix-tree code seems to delegate locking to the caller.
> > 
> > So, is the correct locking present in the page cache?  The radix-tree
> > code seems to assume that all update operations for a given tree are
> > protected by a lock global to that tree.
> 
> The calling code in mm/filemap.c holds mapping->tree_lock when deleting
> radix-tree nodes, so no concurrent calls.
> 
> > Another diagnosis approach would be to build with
> > CONFIG_DEBUG_OBJECTS_RCU_HEAD=y, which would complain about double
> > call_rcu() invocations.  Rumor has it that is is necessary to turn off
> > other kmem debugging for this to tell you anything -- I have seen cases
> > where the kmem debugging obscures the debug-objects diagnostics.
> 
> Another test Jaegeuk could run (hopefully he has some time to look into
> this).

Yap, I'll test this too.
Thanks,

> 
> Thanks for suggestions.
> 

-- 
Jaegeuk Kim
Samsung

