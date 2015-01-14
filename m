Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbbANLA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:00:29 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:41003 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbbANLA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:00:27 -0500
Date: Wed, 14 Jan 2015 22:00:11 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Stephan Mueller <smueller@chronox.de>,
        Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 0/2] crypto: AF_ALG: add AEAD and RNG support
Message-ID: <20150114110011.GA18099@gondor.apana.org.au>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de>
 <20150114094631.GB15294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114094631.GB15294@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:46:31AM -0500, Neil Horman wrote:
> On Wed, Jan 14, 2015 at 04:52:29AM +0100, Stephan Mueller wrote:
> > Hi,
> > 
> > This patch set adds AEAD and RNG support to the AF_ALG interface
> > exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> > support, all cipher types the kernel crypto API allows access to are
> > now accessible from userspace.
> > 
> >  crypto/Kconfig      |   9 +
> >  crypto/Makefile     |   1 +
> >  crypto/algif_aead.c | 680 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 690 insertions(+)
> >  create mode 100644 crypto/algif_aead.c
> > 
> > -- 
> > 2.1.0
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> Where are the RNG bits?

They've already been merged.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
