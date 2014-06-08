Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaFHE4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 00:56:14 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:58143 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaFHE4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 00:56:12 -0400
Date: Sun, 8 Jun 2014 12:55:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Steven Miao <realmz6@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.16
Message-ID: <20140608045559.GA5575@gondor.apana.org.au>
References: <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <CA+55aFz0d4N5hcjqPxzz894WMaoYxBX7rLWXnCa12z=9ogacTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz0d4N5hcjqPxzz894WMaoYxBX7rLWXnCa12z=9ogacTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 07:56:53PM -0700, Linus Torvalds wrote:
> 
> I'm assuming that the delete was actually incorrect, and should have
> been a move, because it looks like the bfin_crc.c file won't compile
> without it. So I've re-instated that file.

Yes that would be my assumption as well.

Sonic/Steven, could you please double-check the current tree to see
whether it's in the right state?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
