Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3BEI2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:28:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3BEI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:28:27 -0500
Date: Tue, 5 Feb 2013 08:28:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan@kernel.org
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-ID: <20130205082822.GE21389@suse.de>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204150657.6d05f76a.akpm@linux-foundation.org>
 <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 08:29:26AM +0900, Kyungmin Park wrote:
> >
> > (This information is needed so that others can make patch-scheduling
> > decisions and should be included in all bugfix changelogs unless it is
> > obvious).
> 
> CMA Highmem support is new feature. so don't need to go stable tree.
> 

You could have given a lot more information to that question!

How new a feature is it? Does this mean that this patch must go in before
3.8 releases or is it a fix against a patch that is only in Andrew's tree?
If the patch is only in Andrew's tree, which one is it and should this be
folded in as a fix?

On a semi-related note; is there a plan for backporting highmem support for
the LTSI kernel considering it's aimed at embedded and CMA was highlighted
in their announcment for 3.4 support?

-- 
Mel Gorman
SUSE Labs
