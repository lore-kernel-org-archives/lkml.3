Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3HPWxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab3HPWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:53:11 -0400
Date: Fri, 16 Aug 2013 17:18:10 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: please fetch new git-based DM 'for-next' branch [was: Re: [git pull]
 device-mapper changes for 3.11]
Message-ID: <20130816211810.GA8668@redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
 <20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
 <20130711135522.GN8530@agk-dp.fab.redhat.com>
 <20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11 2013 at  9:03pm -0400,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alasdair,
> 
> On Thu, 11 Jul 2013 14:55:22 +0100 Alasdair G Kergon <agk@redhat.com> wrote:
> >
> > On Thu, Jul 11, 2013 at 04:20:40PM +1000, Stephen Rothwell wrote:
> > > Alistair, is there some reason that you cannot maintain some relatively
> > > stable git tree for me to fetch (instead of the quilt series).  
> > 
> > Well Mike Snitzer is becoming a joint maintainer and this also requires
> > changes to the workflow so watch this space.
> 
> OK, noted.

Hi Stephen,

To access all future DM changes for linux-next, please switch from
Alasdair's quilt tree to using the 'for-next' branch of the DM git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

Thanks,
Mike
