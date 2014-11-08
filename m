Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKHCVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 21:21:32 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39377 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaKHCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 21:21:31 -0500
Date: Sat, 8 Nov 2014 10:21:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcrl@kvack.org
Subject: Re: [PATCH 1/4] inet: Add skb_copy_datagram_iter
Message-ID: <20141108022121.GA25900@gondor.apana.org.au>
References: <20141105210745.GT7996@ZenIV.linux.org.uk>
 <20141105.165719.835728206041332333.davem@davemloft.net>
 <20141106032533.GU7996@ZenIV.linux.org.uk>
 <20141107.164859.951682597018909290.davem@redhat.com>
 <20141107221114.GB7996@ZenIV.linux.org.uk>
 <20141107234253.GE7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107234253.GE7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:42:53PM +0000, Al Viro wrote:
> I'll finish RTFS drivers/vhost and if it turns out to be OK I'll post the
> series moving those checks to the moment of copying iovec from userland,
> so that kernel-side we could always rely on ->msg_iov elements having been
> verified.

Great thanks!

Dave, please hold off on my skb_copy_datagram_iter series until
this verify_iovec change is added.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
