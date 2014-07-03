Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaGCBB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:01:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50205 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaGCBB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:01:56 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 3 Jul 2014 10:03:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v9] mm: support madvise(MADV_FREE)
Message-ID: <20140703010318.GA2939@bbox>
References: <1404174975-22019-1-git-send-email-minchan@kernel.org>
 <20140701145058.GA2084@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140701145058.GA2084@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 01, 2014 at 05:50:58PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 01, 2014 at 09:36:15AM +0900, Minchan Kim wrote:
> > +	do {
> > +		/*
> > +		 * XXX: We can optimize with supporting Hugepage free
> > +		 * if the range covers.
> > +		 */
> > +		next = pmd_addr_end(addr, end);
> > +		if (pmd_trans_huge(*pmd))
> > +			split_huge_page_pmd(vma, addr, pmd);
> 
> Could you implement proper THP support before upstreaming the feature?
> It shouldn't be a big deal.

Okay, Hope to review.

Thanks for the feedback!

-- 
Kind regards,
Minchan Kim
