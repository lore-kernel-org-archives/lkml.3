Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaKBPOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 10:14:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaKBPOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 10:14:37 -0500
Date: Sun, 2 Nov 2014 23:14:21 +0800
From: Amos Kong <akong@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] hw_random: fix unregister race.
Message-ID: <20141102151421.GB31178@air.redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
 <1411043867-21109-5-git-send-email-akong@redhat.com>
 <20141021141745.GA18511@gondor.apana.org.au>
 <87y4rx860n.fsf@rustcorp.com.au>
 <20141031072321.GB7563@gondor.apana.org.au>
 <20141102150613.GA31178@air.redhat.com>
 <20141102150809.GA23717@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102150809.GA23717@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:08:09PM +0800, Herbert Xu wrote:
> On Sun, Nov 02, 2014 at 11:06:13PM +0800, Amos Kong wrote:
> > On Fri, Oct 31, 2014 at 03:23:21PM +0800, Herbert Xu wrote:
> > > On Fri, Oct 31, 2014 at 10:28:00AM +1030, Rusty Russell wrote:
> > > > Herbert Xu <herbert@gondor.apana.org.au> writes:
> > > > > On Thu, Sep 18, 2014 at 08:37:45PM +0800, Amos Kong wrote:
> > > > >> From: Rusty Russell <rusty@rustcorp.com.au>
> > > > >> 
> > > > >> The previous patch added one potential problem: we can still be
> > > > >> reading from a hwrng when it's unregistered.  Add a wait for zero
> > > > >> in the hwrng_unregister path.
> > > > >> 
> > > > >> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > > >
> > > > > You totally corrupted Rusty's patch.  If you're going to repost
> > > > > his series you better make sure that you've got the right patches.
> > > > >
> > > > > Just as well though as it made me think a little more about this
> > > > > patch :)
> > > > 
> > > > OK Amos, can you please repost the complete series?
> > > 
> > > Please fix the unregister race I identified first.
> > 
> > Ok, I redownload the patches from https://patchwork.kernel.org/project/LKML/list/?submitter=5
> > and rebase fixes of me and rusty on it. I will post a V4 later. Thanks.
> 
> Please fix the unregister race I pointed out before doing a v4.

Thanks for the remind, I got it right now  :-)

-- 
			Amos.
