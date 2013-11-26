Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3KZJod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:44:33 -0500
Received: from [216.32.181.186] ([216.32.181.186]:57476 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab3KZJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:44:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371Ic85fh542I1432Ide40hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh109h2a8h839h8e2h8e3hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1bceh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h20f0h21a6h2216h22d0hbe9i34h1155h)
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: "shh.xie@gmail.com" <shh.xie@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: RE: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Thread-Topic: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Thread-Index: AQHO6nwiP7m/Ap0cME2qdHvtdMjl2Jo3I4hQ
Date: Tue, 26 Nov 2013 09:43:05 +0000
Message-ID: <B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44@039-SN2MPN1-023.039d.mgd.msft.net>
References: <1385447405-7784-1-git-send-email-shh.xie@gmail.com>
In-Reply-To: <1385447405-7784-1-git-send-email-shh.xie@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.60]
Content-Type: multipart/mixed;
	boundary="_002_B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44039SN2MPN102303_"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44039SN2MPN102303_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

A Patch for this has already been submitted.

Regards,
Ruchika

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of shh.xie@gmail.com
> Sent: Tuesday, November 26, 2013 12:00 PM
> To: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: herbert@gondor.hengli.com.au; davem@davemloft.net; Xie Shaohui-B21989
> Subject: [PATCH] crypto/caam/jr.c: include linux/of_address.h
>=20
> From: Shaohui Xie <Shaohui.Xie@freescale.com>
>=20
> to avoid a compile error:
>=20
> drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
> drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function
> 'of_iomap' [-Werror=3Dimplicit-function-declaration]
> drivers/crypto/caam/jr.c:468:7: warning: assignment makes pointer from
> integer without a cast [enabled by default]
>=20
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> ---
>  drivers/crypto/caam/jr.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> d23356d2..1d80bd3 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -6,6 +6,7 @@
>   */
>=20
>  #include <linux/of_irq.h>
> +#include <linux/of_address.h>
>=20
>  #include "compat.h"
>  #include "regs.h"
> --
> 1.8.4.1
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_002_B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44039SN2MPN102303_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Tue, 26 Nov 2013 09:43:03 GMT";
	modification-date="Tue, 26 Nov 2013 09:43:03 GMT"

From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: Michael Neuling <mikey@neuling.org>
CC: Vakul Garg <vakul@freescale.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: RE: [PATCH] crypto: caam - Add missing Job Ring include
Thread-Topic: [PATCH] crypto: caam - Add missing Job Ring include
Thread-Index: AQHO5BV32tLO7FiHcEefwribOqzGAZor6Bbw
Date: Tue, 19 Nov 2013 04:17:29 +0000
References: <7301.1384748401@ale.ozlabs.ibm.com>
In-Reply-To: <7301.1384748401@ale.ozlabs.ibm.com>
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Acked-by: Ruchika Gupta <ruchika.gupta@freescale.com>

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Michael Neuling
> Sent: Monday, November 18, 2013 9:50 AM
> To: Gupta Ruchika-R66431
> Cc: Garg Vakul-B16394; Herbert Xu; linux-crypto@vger.kernel.org;
> sfr@canb.auug.org.au
> Subject: [PATCH] crypto: caam - Add missing Job Ring include
>
> linuxnext currently doesn't compile with the powerpc mpc85xx_defconfig
> giving:
>
>   drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
>   drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function
> 'of_iomap' [-Werror=3Dimplicit-function-declaration]
>
> In:
>   commit 313ea293e9c4d1eabcaddd2c0800f083b03c2a2e
>   Author: Ruchika Gupta <ruchika.gupta@freescale.com>
>   crypto: caam - Add Platform driver for Job Ring
>
> We added a reference to of_iomap but did add the necessary include file.
>
> The below adds this include.
>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
>
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c index
> d23356d2..1d80bd3 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -6,6 +6,7 @@
>   */
>
>  #include <linux/of_irq.h>
> +#include <linux/of_address.h>
>
>  #include "compat.h"
>  #include "regs.h"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" i=
n
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


--_002_B2B5EF0D8FDD10429C8DE6C4C2B382820947AA44039SN2MPN102303_--
