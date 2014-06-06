Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFFUTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:19:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaFFUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:19:46 -0400
Date: Fri, 6 Jun 2014 13:19:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, jwboyer@fedoraproject.org,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: pte_present check on hugetlb_entry fix for 3.15?
Message-Id: <20140606131944.8302a87925711fb91e0a10db@linux-foundation.org>
In-Reply-To: <53922054.6020108@intel.com>
References: <20140606173546.GA1869@zod>
	<53920c95.685a8c0a.2111.ffffe52fSMTPIN_ADDED_BROKEN@mx.google.com>
	<20140606115919.df17197c7182a0f7ed59c3a9@linux-foundation.org>
	<53922054.6020108@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 13:11:00 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 06/06/2014 11:59 AM, Andrew Morton wrote:
> > On Fri,  6 Jun 2014 14:46:37 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> >> On Fri, Jun 06, 2014 at 01:36:54PM -0400, Josh Boyer wrote:
> >>> Hi Naoya,
> >>>
> >>> I noticed that your
> >>> mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch in
> >>> Andrew's -mm tree has been queued for a while and has a CC to stable on
> >>> it.  Is that something that should get into 3.15?
> >>
> >> I'm not sure. I guess Andrew will decide this in a few days.
> > 
> > I was planning on doing so but then Dave popped up with an alternative
> > which rather blew a hole in things.
> 
> This one patch is independent from what I was posting.  I don't think my
> patch would have had any effect on the behavior this one is fixing.
> 
> IOW, don't hold it up for my (or my patches) benefit.

I was referring to these, which remain in limbo:

mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch

Some energy in driving all this toward some sort of conclusion would be
appreciated.
