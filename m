Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab3K2Its (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:49:48 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19090
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab3K2Itq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:49:46 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0h2336hbe9i1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Thread-Topic: [PATCH] crypto: remove unnecessary includes
Thread-Index: AQHO7F2WLzAy+Wj4w0mRxS12fEJIVJo7dqIAgABwEFA=
Date: Fri, 29 Nov 2013 08:49:42 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
In-Reply-To: <20131129020657.GA5650@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.171.73.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I could see there is nothing from those includes that is used inside authenc.c.
The build passes without them.

Cristian S.

> > diff --git a/crypto/authenc.c b/crypto/authenc.c
> > index 1875e70..7d4bfaa 100644
> > --- a/crypto/authenc.c
> > +++ b/crypto/authenc.c
> > @@ -17,11 +17,8 @@
> >  #include <crypto/scatterwalk.h>
> >  #include <linux/err.h>
> >  #include <linux/init.h>
> > -#include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/rtnetlink.h>
> > -#include <linux/slab.h>
> > -#include <linux/spinlock.h>
> >
> >  typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int
> flags);
> 
> Why are these includes unnecessary?
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


