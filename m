Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaJJSA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:00:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56691 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaJJSA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:00:56 -0400
Date: Fri, 10 Oct 2014 12:59:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/12] rtc: omap: remove redundant debug message
Message-ID: <20141010175958.GQ31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-6-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8mP+8RrBGerSNjm"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-6-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--p8mP+8RrBGerSNjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:27PM +0200, Johan Hovold wrote:
> Remove redundant debug message.
>=20
> The corresponding error has already been logged by rtc core.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/rtc/rtc-omap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index d1b5562a148b..e50ffd7063f5 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -485,11 +485,9 @@ static int __init omap_rtc_probe(struct platform_dev=
ice *pdev)
> =20
>  	rtc =3D devm_rtc_device_register(&pdev->dev, pdev->name,
>  			&omap_rtc_ops, THIS_MODULE);
> -	if (IS_ERR(rtc)) {
> -		pr_debug("%s: can't register RTC device, err %ld\n",
> -			pdev->name, PTR_ERR(rtc));
> +	if (IS_ERR(rtc))
>  		goto fail0;
> -	}
> +
>  	platform_set_drvdata(pdev, rtc);
> =20
>  	return 0;
> --=20
> 2.0.4
>=20

--=20
balbi

--p8mP+8RrBGerSNjm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB6eAAoJEIaOsuA1yqREY+IP/RNJqrCSHs6kaFnheVi0cyrz
a082SQ/y/A7pAreJ73hwfXx+pu5GGMQsqErFFTfrxB++hYL/eXTC0oDu9iZYyT2v
MTZHFTLCYUCRcww1qm7s5JExxEUPF9sfQcd3mnxfEqLjLQMAhSqF2RcIRglk2HBi
/uIhZ6clC8pdAormZksGDGQCG1vAmKLGVvh8aEAJqCglX++vCxgXVh5JF0l9f3vD
20NgkWUs0haw1hVH9cw3Ds/i/DylIyLIRQdrdDthqIUmT6eQSq/5tl+wptBwZWdF
/fR8ynFFzj/ACiq3MloMt2dUiGxXOWH0acYxchTNV4XUjGKr2oUPnL5NiPGMVpu8
IrEEY6Rm0PghUqviqvCTStHhd7LvcasVLLK6X9vziDZkfwlZ/8S9heOCB73surQD
pQ4oki5HhFKkq4vpeeBc2FpI6Wf0enDTv1p7dG02+z/50x5pDp+1Odi/4HTcJDjI
mfAG9yeU0YvcW/6Eo1LZ+jTnq5kYX4VQUqLJB3wEpjw/H7XJI8iJiIRv4Gdaa4Lm
voFq/K8VIrhhMXogaOMhCdPaHwlJEAQ5bgUH28K9W0NwFT73e3t1gAZgZlDuertT
XkudJxqcHls9rbKI3UPQwEyPJ/vBXvwX2bzsZcrwwbZvuRTN3uWu6Mkp50Ue+cpQ
rXNwnflMOudYuuSrigt/
=jXL+
-----END PGP SIGNATURE-----

--p8mP+8RrBGerSNjm--
