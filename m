Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3LEJKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:10:55 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:24734
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab3LEJKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:10:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0h2336hbe9i1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Thread-Topic: [PATCH] crypto: remove unnecessary includes
Thread-Index: AQHO7F2WLzAy+Wj4w0mRxS12fEJIVJo7dqIAgABwEFCAAC6BAIAABtkAgAkuiUCAAALrAIAAArsA
Date: Thu, 5 Dec 2013 09:10:27 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE78DC8B@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
 <1628287275CAA9409F1E349DEF3C6CCE78CBF0@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131205082220.GB31822@gondor.apana.org.au>
In-Reply-To: <20131205082220.GB31822@gondor.apana.org.au>
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

> If you can't work out why authenc.c needs slab.h I don't think
> you should be submitting patches removing unnecessary header
> files.

[] 
You left out "kernel.h".

I really hoped this would not be your answer.

Yes, I'm an ignorant and yes, I ask questions. But if all you got is this type of answer, then maybe, just maybe, you should reconsider your ivory tower position.
The point is, if it's such a simple and obvious explanation, you should have said it instead of making me feel small. If it is not, then you should fix the pool of missing comments in crypto API (or should I read the obvious code instead?).
Even Linus pointed your mistakes when it was the case - or you never make mistakes?

You tried but your answer doesn't raise to the level of "kernel-locking.tmpl" one (and yes, I do get the "why" there).
For anyone else who cares, please lift me up from my ignorance.

Cristian S.


