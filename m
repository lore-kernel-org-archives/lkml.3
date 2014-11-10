Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaKJHxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:53:16 -0500
Received: from mail.eperm.de ([89.247.134.16]:54306 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaKJHxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:53:13 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tstruk@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level spec
Date: Mon, 10 Nov 2014 02:41:56 +0100
Message-ID: <6378539.AB6lySjknM@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <545AD9B0.4090009@gmail.com>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de> <4163724.RCMDlx8dmE@tachyon.chronox.de> <545AD9B0.4090009@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. November 2014, 18:15:12 schrieb Tadeusz Struk:

Hi Tadeusz,

> Hi,
> 
> On 11/02/2014 12:35 PM, Stephan Mueller wrote:
> > +	* type:
> > +		- blkcipher for symmetric block ciphers
> 
> blkcipher for synchronous block ciphers
> 
> > +		- ablkcipher for asymmetric block ciphers
> 
> ablkcipher for asynchronous block ciphers
> 
> > +		- cipher for single block ciphers that may be used with an
> > +		  additional template
> > +		- shash for symmetric message digest
> 
> shash for synchronous message digest
> 
> > +		- ahash for asymmetric message digest
> 
> ahash for asynchronous message digest
> 
> T.

Thanks a lot for this hint: I do not know how often I said "symmetric" or 
"asymmetric" when in fact I meant synchronous and asynchronous....

Maybe I spent too much time in the crypto arena ;-)

-- 
Ciao
Stephan
