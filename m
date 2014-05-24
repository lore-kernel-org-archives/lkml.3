Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaEXAhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaEXAhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:37:17 -0400
Date: Fri, 23 May 2014 20:37:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: slab_common: fix the check for duplicate slab names
Message-ID: <20140524003703.GA17250@redhat.com>
References: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com>
 <20140325170324.GC580@redhat.com>
 <alpine.DEB.2.10.1403251306260.26471@nuc>
 <20140523201632.GA16013@redhat.com>
 <537FBD6F.1070009@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537FBD6F.1070009@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23 2014 at  5:28pm -0400,
Pekka Enberg <penberg@iki.fi> wrote:

> On 05/23/2014 11:16 PM, Mike Snitzer wrote:
> >On Tue, Mar 25 2014 at  2:07pm -0400,
> >Christoph Lameter <cl@linux.com> wrote:
> >
> >>On Tue, 25 Mar 2014, Mike Snitzer wrote:
> >>
> >>>This patch still isn't upstream.  Who should be shepherding it to Linus?
> >>Pekka usually does that.
> >>
> >>Acked-by: Christoph Lameter <cl@linux.com>
> >This still hasn't gotten upstream.
> >
> >Pekka, any chance you can pick it up?  Here it is in dm-devel's
> >kernel.org patchwork: https://patchwork.kernel.org/patch/3768901/
> >
> >(Though it looks like it needs to be rebased due to the recent commit
> >794b1248, should Mikulas rebase and re-send?)
> 
> I applied it and fixed the conflict by hand.
> 
> Please double-check commit 694617474e33b8603fc76e090ed7d09376514b1a
> in my tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/penberg/linux.git/

Looks good, thanks.
