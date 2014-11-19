Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaKSBFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:05:30 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35761 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaKSBF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:05:28 -0500
Date: Wed, 19 Nov 2014 09:05:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher
 info
Message-ID: <20141119010516.GA18238@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2688209.3bGZus2TD9@tachyon.chronox.de>
 <20141118140822.GB12100@gondor.apana.org.au>
 <34547475.R7WC8JFgoJ@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34547475.R7WC8JFgoJ@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 02:02:33AM +0100, Stephan Mueller wrote:
>
> I am wondering why cryptouser.h is in include/linux -- shouldn't it be in 
> include/uapi/linux? Aren't the definitions in that header file needed for 
> userspace to talk to the netlink socket? I guess that is also the reason why I 

It should be.  I think crypto_user predates the uapi split so
that's probably why it's in the wrong place.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
