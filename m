Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaLFX2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 18:28:30 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:46372 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaLFX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 18:28:28 -0500
Date: Sun, 7 Dec 2014 07:28:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Message-ID: <20141206232823.GB6409@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <4875720.jRoMDtjHB4@tachyon.chronox.de>
 <20141205154606.GA30180@gondor.apana.org.au>
 <45756810.oFuGYtKPb9@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45756810.oFuGYtKPb9@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:51:51PM +0100, Stephan Mueller wrote:
>
> Would you please be so kind and help me understand when some operations are 
> intended for the parent FD and when for the child FD?

If it changes the tfm it goes in the parent FD otherwise it's the
child FD.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
