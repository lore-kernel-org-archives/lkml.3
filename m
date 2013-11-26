Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3KZKFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:05:45 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:27182
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab3KZKFl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:05:41 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I103dK542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068ha509lz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: Ruchika Gupta <ruchika.gupta@freescale.com>,
        "shh.xie@gmail.com" <shh.xie@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Thread-Topic: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Thread-Index: AQHO6nwawWndADUzUE6qvxTN3NtBaJo3QteAgAAFwwA=
Date: Tue, 26 Nov 2013 10:05:23 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C91516D92F@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385447405-7784-1-git-send-email-shh.xie@gmail.com>
 <B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44@039-SN2MPN1-023.039d.mgd.msft.net>
In-Reply-To: <B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44@039-SN2MPN1-023.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!
I'm not in the list, did not see the patch.
So just ignore this patch.

Best Regards, 
Shaohui Xie


> -----Original Message-----
> From: Gupta Ruchika-R66431
> Sent: Tuesday, November 26, 2013 5:43 PM
> To: shh.xie@gmail.com; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: herbert@gondor.hengli.com.au; davem@davemloft.net; Xie Shaohui-B21989
> Subject: RE: [PATCH] crypto/caam/jr.c: include linux/of_address.h
> 
> A Patch for this has already been submitted.
> 
> Regards,
> Ruchika
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> > owner@vger.kernel.org] On Behalf Of shh.xie@gmail.com
> > Sent: Tuesday, November 26, 2013 12:00 PM
> > To: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: herbert@gondor.hengli.com.au; davem@davemloft.net; Xie
> > Shaohui-B21989
> > Subject: [PATCH] crypto/caam/jr.c: include linux/of_address.h
> >
> > From: Shaohui Xie <Shaohui.Xie@freescale.com>
> >
> > to avoid a compile error:
> >
> > drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
> > drivers/crypto/caam/jr.c:468:2: error: implicit declaration of
> > function 'of_iomap' [-Werror=implicit-function-declaration]
> > drivers/crypto/caam/jr.c:468:7: warning: assignment makes pointer from
> > integer without a cast [enabled by default]
> >
> > Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> > ---
> >  drivers/crypto/caam/jr.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> > d23356d2..1d80bd3 100644
> > --- a/drivers/crypto/caam/jr.c
> > +++ b/drivers/crypto/caam/jr.c
> > @@ -6,6 +6,7 @@
> >   */
> >
> >  #include <linux/of_irq.h>
> > +#include <linux/of_address.h>
> >
> >  #include "compat.h"
> >  #include "regs.h"
> > --
> > 1.8.4.1
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-crypto" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


