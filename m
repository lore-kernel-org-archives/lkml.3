Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbaJaHXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:23:42 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46970 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaJaHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:23:40 -0400
Date: Fri, 31 Oct 2014 15:23:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amos Kong <akong@redhat.com>, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] hw_random: fix unregister race.
Message-ID: <20141031072321.GB7563@gondor.apana.org.au>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
 <1411043867-21109-5-git-send-email-akong@redhat.com>
 <20141021141745.GA18511@gondor.apana.org.au>
 <87y4rx860n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4rx860n.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:28:00AM +1030, Rusty Russell wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> > On Thu, Sep 18, 2014 at 08:37:45PM +0800, Amos Kong wrote:
> >> From: Rusty Russell <rusty@rustcorp.com.au>
> >> 
> >> The previous patch added one potential problem: we can still be
> >> reading from a hwrng when it's unregistered.  Add a wait for zero
> >> in the hwrng_unregister path.
> >> 
> >> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >
> > You totally corrupted Rusty's patch.  If you're going to repost
> > his series you better make sure that you've got the right patches.
> >
> > Just as well though as it made me think a little more about this
> > patch :)
> 
> OK Amos, can you please repost the complete series?

Please fix the unregister race I identified first.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
