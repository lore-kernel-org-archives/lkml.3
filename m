Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaKSDKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:10:37 -0500
Received: from mail.eperm.de ([89.247.134.16]:54644 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbaKSDKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:10:35 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Date: Wed, 19 Nov 2014 03:36:45 +0100
Message-ID: <9023565.IShqyyQhGs@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141118141013.GC12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <2196615.OgfUNzPKdf@tachyon.chronox.de> <20141118141013.GC12100@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. November 2014, 22:10:13 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 16, 2014 at 03:26:58AM +0100, Stephan Mueller wrote:
> > The current AF_ALG implementation requires that a userspace interface
> > implementation must provide a callback for setkey. Such a call is not
> > appliable to random number generators.
> > 
> > To prepare AF_ALG for the addition of a random number generator user
> > space interface, this function callback invocation is made optional.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Did you actually try this? AFAICS setkey is already optional.

You are correct. I tested the kernel without my patch and the setkey on the 
RNG handle is rejected. I now also see the check already present in the 
alg_setkey function.

This patch will be removed from a new patchset.
> 
> Cheers,


-- 
Ciao
Stephan
