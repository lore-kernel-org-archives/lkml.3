Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKGB7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:59:53 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:46782 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKGB7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:59:51 -0500
Date: Fri, 7 Nov 2014 09:59:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141107015944.GB9101@gondor.apana.org.au>
References: <E1XlZWY-0003HZ-Ef@gondolin.me.apana.org.au>
 <20141105.152410.1775725940252546246.davem@davemloft.net>
 <20141106082338.GA29800@gondor.apana.org.au>
 <20141106.122500.4643339498907490.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106.122500.4643339498907490.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:25:00PM -0500, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Thu, 6 Nov 2014 16:23:38 +0800
> 
> > On Wed, Nov 05, 2014 at 03:24:10PM -0500, David Miller wrote:
> >> 
> >> Herbert, please provide a cover letter for this series, and the most recent
> >> version of patch #2 gets various rejects when I try to apply it to net-next.
> > 
> > Sure, I'll regenerate them.  However, while doing so I noticed that
> > a number of my patches on tun/macvtap that you have previously set
> > as accepted are missing from net-next.  Could this be why you got
> > the rejects?
> 
> Those were bug fixes so went into plain 'net', they will show up next
> time I do a merge and I will deal with the conflicts, if any.

I see.  In that case it might be best to wait until those fixes hit
net-next first before applying these patches as otherwise Stephen will
get hit with some nasty merge conflicts.

I'll repost them for RFC with the problems that Al pointed out fixed
in the mean time.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
