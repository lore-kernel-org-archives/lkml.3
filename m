Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaDNMoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:44:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50397 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaDNMoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:44:13 -0400
Message-ID: <534BD810.3010705@ti.com>
Date: Mon, 14 Apr 2014 15:44:00 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Miao <realmz6@kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>
Subject: Re: [PATCH] video: bf54x-lq043fb: fix build error
References: <1397266245-3144-1-git-send-email-realmz6@kernel.org>
In-Reply-To: <1397266245-3144-1-git-send-email-realmz6@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="wWBWwpluNplMpxweXAhvDcfQItoOXvMEG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wWBWwpluNplMpxweXAhvDcfQItoOXvMEG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/04/14 04:30, Steven Miao wrote:
> From: Steven Miao <realmz6@gmail.com>
>=20
> should include linux/gpio.h
>=20
> Signed-off-by: Steven Miao <realmz6@gmail.com>
> ---
>  drivers/video/bf54x-lq043fb.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043f=
b.c
> index 42b8f9d..d2b54f1 100644
> --- a/drivers/video/bf54x-lq043fb.c
> +++ b/drivers/video/bf54x-lq043fb.c
> @@ -49,6 +49,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/platform_device.h>
> +#include <linux/gpio.h>

The driver includes <asm/gpio.h>. I think that should be removed, and
<linux/gpio.h> should be used.

Can you also remove the asm/gpio.h in your patch, and see if it compiles
fine?

 Tomi



--wWBWwpluNplMpxweXAhvDcfQItoOXvMEG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTS9gQAAoJEPo9qoy8lh71+28QAJd0lWaGhMTxsFWFX+gmov6P
o0sPMJUBRE6SzCKpLL9jc8RGkwQqgO4DEwhjUW2sjDZCF+5sL5TmNBLpGzpBrCYY
vf+NpX8qoH73FQCDNq5KdQ7hCM7u7ncQYA1q3uvPkDwPc2Ng79ymf50Ipdjktm2W
zUOax0oZcM/ma12ZeDqK9PADvfo/i/Fa+vF9W2on8javcBbPVN9n79mMqBb/SMGl
KSS20kaS7XZ98AX3cq4/VHFrwnU+ruYUGJn1xg9AK77VjvqcPpgkw3vWXXsbLy2R
eCP117dKOTPy8Jx/jlsj4Dp0T4MAx/G+qJD/tzgF2K5/CIoSooX9W9aNt9qE8jIj
pcGx9nn5nfCaKJd9jpLtTo6ZB8aIb9mBjuLYFmVoaL91+MTtXJteBZfsWLwmlarI
sE8oaLNwPIfc3YRDsDzHUzPP1l4Tb7NLmdWRx+i/EiIyLaSE9N5bZRSGxF60WbxU
NXnDR95QW+BYG48DSgbYeFQI9BEsXAwF64/ieo0sONOZoU+OyuWWrPlfOOuHRzSX
sR4spMAarTVhBam7wH1sGpohRZY/ooLO09Hj5aGTLJHxSfuktlDTHaWKlEVCnRjt
n24shCmzgUe5y0BH21CbXjzulPncdf3wTLpLR/EIiSbOKdH5J+xJmXLQj4vqCGuz
0mlo4ACizNfBZcJhdMu7
=nbAj
-----END PGP SIGNATURE-----

--wWBWwpluNplMpxweXAhvDcfQItoOXvMEG--
