Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936045Ab3DHUWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936007Ab3DHUWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:22:22 -0400
Date: Mon, 08 Apr 2013 16:21:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Message-ID: <1365452486-arj4q4xd-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <515F3F5C.2090709@gmail.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F3F5C.2090709@gmail.com>
Subject: Re: [PATCH 05/10] migrate: add hugepage migration code to
 migrate_pages()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <515F3F5C.2090709@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:17:16PM -0400, KOSAKI Motohiro wrote:
> (3/22/13 4:23 PM), Naoya Horiguchi wrote:
> > This patch extends check_range() to handle vma with VM_HUGETLB set.
> > We will be able to migrate hugepage with migrate_pages(2) after
> > applying the enablement patch which comes later in this series.
> > 
> > Note that for larger hugepages (covered by pud entries, 1GB for
> > x86_64 for example), we simply skip it now.
> 
> check_range() has largely duplication with mm_walk and it is quirk subset.
> Instead of, could you replace them to mm_walk and enhance/cleanup mm_walk?

OK, I'll try this.

Thanks,
Naoya
