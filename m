Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaKQCeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:34:01 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57916 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaKQCd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:33:59 -0500
Date: Mon, 17 Nov 2014 10:33:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally
 generated queries
Message-ID: <20141117023309.GA30015@gondor.apana.org.au>
References: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
 <20141102220145.GA25604@gondor.apana.org.au>
 <20141117020816.GD2469@odroid>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141117020816.GD2469@odroid>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 03:08:16AM +0100, Linus Lüssing wrote:
> On Mon, Nov 03, 2014 at 06:01:46AM +0800, Herbert Xu wrote:
> > On Mon, Sep 22, 2014 at 01:32:44AM +0200, Linus Lüssing wrote:
> > > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> > 
> > Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Hi David,
> 
> are there any unanswered questions left?

Please resubmit your patch as it's no longer in David's queue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
