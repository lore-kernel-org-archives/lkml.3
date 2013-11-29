Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3K2MHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:07:14 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:8835
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab3K2MHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:07:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0h2336hbe9i1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Thread-Topic: [PATCH] crypto: remove unnecessary includes
Thread-Index: AQHO7F2WLzAy+Wj4w0mRxS12fEJIVJo7dqIAgABwEFCAAC6BAIAABtkA
Date: Fri, 29 Nov 2013 12:07:07 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
In-Reply-To: <20131129113430.GA9542@gondor.apana.org.au>
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

> On Fri, Nov 29, 2013 at 08:49:42AM +0000, Cristian Stoica wrote:
> > >From what I could see there is nothing from those includes that is
> used inside authenc.c.
> > The build passes without them.
> 
> Just because it compiles it doesn't meant that the files you
> removed are unnecessary.
> 
> The only file that is really unnecessary here is spinlock.h.
> 
[] 
OK then, but let's reverse the question. In a construct similar to authenc.c, what would be the purpose of slab.h and kernel.h?
(That leads to the next question which is - what is the purpose of those files in authenc.c?)

Thanks,
Cristian S.

