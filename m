Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaJORpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:45:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:47412 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaJORpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:45:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="asc'?scan'208";a="589600218"
Message-ID: <1413394958.2412.23.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 10:42:38 -0700
In-Reply-To: <1413389496.7484.3.camel@perches.com>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
	 <1413389496.7484.3.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MYXLGxpx2/uJuEIvRZis"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MYXLGxpx2/uJuEIvRZis
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 09:11 -0700, Joe Perches wrote:
> On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
> []
> > I thought I remember Greg saying something about getting rid of this
> > driver anyway, but I could be wrong.  If Greg decides to keep this
> > driver around, then I think we should something like your suggestion
> > above.
>=20
> Or maybe just make the Kconfig depend on X86_32

I like the idea, but won't this exclude other 32 bit systems like MIPS
and I am sure there might be others.  I could assume that Beceem WIMAX
was intended for x86 arch's that are 32 bit only, which may be a safe
bet.  The only thing we know for sure is that is broken on 64bit.

> ---
>  drivers/staging/bcm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
> index 8acf4b2..fa5a3a4 100644
> --- a/drivers/staging/bcm/Kconfig
> +++ b/drivers/staging/bcm/Kconfig
> @@ -1,6 +1,6 @@
>  config BCM_WIMAX
>         tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
> -       depends on USB && NET
> +       depends on USB && NET && X86_32
>         help
>           This is an experimental driver for the Beceem WIMAX chipset use=
d
>  	 by Sprint 4G.
>=20
>=20



--=-MYXLGxpx2/uJuEIvRZis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPrIOAAoJEOVv75VaS+3OxCMP/inSqfM7RHnJohZzwKkotKw9
qbAyYZGIIe6sNVlW4RS4XRPcbmNSriOd0g/pOo6PNH422WcSs7cvNBJLmZF1PklQ
l0goyWYbouqmIHII32cHt530pVPffQahsJ8f3k4u3sPKGqZ+dgJBKRHVVNXI0Kd2
PpEXGNCI9z2Xp8E5yRdGZXgWHuYvjv8oOKOVAauP9r6Y/GAUIJT2IqhY8sFdEAcQ
JPc2ZC0g5R3JFFr2EJIC3I2saKjtNW/c3EBrHAeCXLX8d+B/4K3DOj4gc7jD5HNt
EiMQ1AVgphExKBvi/16vTC+U6kTsDR/S/zkkpPVRfxClnGUhdLfa+HY078y9CbbZ
0/ppnm+ZnFnsAZFAWTo8+W8Nfv+nCdeL/KhaCHwRN4dnkY2n2YxbnBaSPJGIh8mx
j0UjPtE8iO5XJilINu81VLYNiz+aMFcRcEGA56BERG0bqwNjEnXVrZDrsw5RoGDF
lUDi0RXjqdsUfbSAC3Sn97PSRhMzE4L8HJfFI0xaDyl+Iw7+RWN/anv1DSWlxO6J
HuF9Jl9BKZPymWT6gK4K58pDKyPcjFhQGm7TrWqR2kMqoc5VzbiQfeTXByOGjH/H
XH80JmlubdhBGOscQYjm8gyoEnp1/jCE4pNmnb+vW6VzfC7+VVodWktUDOGx93Na
qonY5w9m1qGqLgo/Upv5
=0yMp
-----END PGP SIGNATURE-----

--=-MYXLGxpx2/uJuEIvRZis--

