Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbbATDrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:47:52 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55821 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbATDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:47:50 -0500
Date: Tue, 20 Jan 2015 14:47:35 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Amos Kong <akong@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] virtio_rng: drop extra empty line
Message-ID: <20150120034735.GA11274@gondor.apana.org.au>
References: <1421322638-21320-1-git-send-email-mst@redhat.com>
 <20150115232109.GA5626@gondor.apana.org.au>
 <20150116071600.GA12274@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116071600.GA12274@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 09:16:00AM +0200, Michael S. Tsirkin wrote:
> On Fri, Jan 16, 2015 at 10:21:09AM +1100, Herbert Xu wrote:
> > On Thu, Jan 15, 2015 at 01:50:42PM +0200, Michael S. Tsirkin wrote:
> > > makes code look a bit prettier.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Please resend this patch with a cc to linux-crypto@vger.kernel.org.
> > 
> > Thanks!
> 
> So let's add this to maintainers?
> Will you ack something like below?
> 
> --->
> 
> 
> MAINTAINERS: add linux-crypto to hw random
> 
> hw random is crypto-related, Cc the linux-crypto list
> on patches.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
