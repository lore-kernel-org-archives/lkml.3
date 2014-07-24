Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaGXIzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54221 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGXIzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:55:10 -0400
Date: Thu, 24 Jul 2014 09:54:56 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Hugh Dickins <hughd@google.com>
Cc: Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
Message-ID: <20140724085456.GA5733@hercules>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
 <1406067727-19683-108-git-send-email-kamal@canonical.com>
 <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
 <1406149325.3612.33.camel@fourier>
 <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:07:16PM -0700, Hugh Dickins wrote:
> On Wed, 23 Jul 2014, Kamal Mostafa wrote:
> > On Tue, 2014-07-22 at 16:08 -0700, Hugh Dickins wrote:
> > > On Tue, 22 Jul 2014, Kamal Mostafa wrote:
> > > 
> > > > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > > 
> > > > commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
> > > > 
> > > > There's a race between fork() and hugepage migration, as a result we try
> > > > [...]
> > > 
> > > Please drop this one for now: other -stables have carried it, but it
> > > was found last week to contain a bug of its own, arguably worse than
> > > what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
> > > and should make its way to Linus probably this week: so please hold
> > > this back until that can join it - thanks.
> > > 
> > > Hugh
> > 
> > OK, I've dropped it from the 3.8-stable queue, and will watch for the
> > fix to land.  Thanks very much, Hugh!
> 
> commit 0253d634e0803a8376a0d88efee0bf523d8673f9
> Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date:   Wed Jul 23 14:00:19 2014 -0700
> mm: hugetlb: fix copy_hugetlb_page_range()
> 
> is now in Linus's tree: so the original patch is good to go into
> your -stables, so long as you add 0253d634e080 on top.
> 

Awesome, I'll queue both for the 3.11 kernel as well.  Thanks Hugh!

Cheers,
--
Luís
