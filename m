Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaEIMv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:51:59 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:38579 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:51:58 -0400
Date: Fri, 9 May 2014 20:51:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        Matthias-Christian Ott <ott@mirix.org>
Subject: Re: linux-next: manual merge of the crypto tree with Linus' tree
Message-ID: <20140509125151.GA22796@gondor.apana.org.au>
References: <20140509120702.62c609a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509120702.62c609a3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:07:02PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> Today's linux-next merge of the crypto tree got a conflict in
> crypto/crypto_user.c between commit 90f62cf30a78 ("net: Use
> netlink_ns_capable to verify the permisions of netlink messages") from
> Linus' tree and commit c568398aa05f ("crypto: user - Allow
> CRYPTO_MSG_GETALG without CAP_NET_ADMIN") from the crypto tree.
> 
> I fixed it up (I hope - see below) and can carry the fix as necessary
> (no action is required).

Looks good.  Thanks Stephen!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
