Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbaGWVCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:02:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbaGWVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:02:16 -0400
Message-ID: <1406149325.3612.33.camel@fourier>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
From: Kamal Mostafa <kamal@canonical.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Jul 2014 14:02:05 -0700
In-Reply-To: <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-108-git-send-email-kamal@canonical.com>
	 <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 16:08 -0700, Hugh Dickins wrote:
> On Tue, 22 Jul 2014, Kamal Mostafa wrote:
> 
> > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
> > 
> > There's a race between fork() and hugepage migration, as a result we try
> > [...]
> 
> Please drop this one for now: other -stables have carried it, but it
> was found last week to contain a bug of its own, arguably worse than
> what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
> and should make its way to Linus probably this week: so please hold
> this back until that can join it - thanks.
> 
> Hugh

OK, I've dropped it from the 3.8-stable queue, and will watch for the
fix to land.  Thanks very much, Hugh!

 -Kamal


