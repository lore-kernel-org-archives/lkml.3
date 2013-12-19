Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3LSMQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:16:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab3LSL7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:08 -0500
Date: Thu, 19 Dec 2013 11:59:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/18] mm: numa: Avoid unnecessary disruption of NUMA
 hinting during migration
Message-ID: <20131219115905.GI11295@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
 <1386690695-27380-11-git-send-email-mgorman@suse.de>
 <52B0D5F9.5030208@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52B0D5F9.5030208@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:53:45PM -0500, Sasha Levin wrote:
> Hi Mel,
> 
> On 12/10/2013 10:51 AM, Mel Gorman wrote:
> >+
> >+	/* mmap_sem prevents this happening but warn if that changes */
> >+	WARN_ON(pmd_trans_migrating(pmd));
> >+
> 
> I seem to be hitting this warning with latest -next kernel:
> 

Patch will follow shortly. I appreciate these trinity bug reports but in
the future is there any chance you could include the trinity command line
and the config file you used? Details on the machine would also be nice. In
this case, knowing if the machine was NUMA or not would have been helpful.

Thanks!

-- 
Mel Gorman
SUSE Labs
