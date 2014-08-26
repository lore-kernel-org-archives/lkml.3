Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaHZMlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:41:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41085 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaHZMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:41:13 -0400
Message-ID: <53FC805F.5040807@ti.com>
Date: Tue, 26 Aug 2014 15:41:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] video: vermilion: remove unnecessary break after
 goto
References: <1404836838-6953-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404836838-6953-1-git-send-email-fabf@skynet.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7UJuFtT020P8oFaEMoTxmTIhOSO4rH1lL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7UJuFtT020P8oFaEMoTxmTIhOSO4rH1lL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/07/14 19:27, Fabian Frederick wrote:
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/video/fbdev/vermilion/vermilion.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/=
fbdev/vermilion/vermilion.c
> index 048a666..5f930ae 100644
> --- a/drivers/video/fbdev/vermilion/vermilion.c
> +++ b/drivers/video/fbdev/vermilion/vermilion.c
> @@ -481,7 +481,6 @@ static int vml_pci_probe(struct pci_dev *dev, const=
 struct pci_device_id *id)
>  	default:
>  		err =3D -ENODEV;
>  		goto out_err_1;
> -		break;
>  	}
> =20
>  	info =3D &vinfo->info;
>=20

Thanks, queued for 3.18.

 Tomi



--7UJuFtT020P8oFaEMoTxmTIhOSO4rH1lL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/IBfAAoJEPo9qoy8lh71sdEP/0Z+UCpOkK+72kYyX84hIoz6
FETMfIcoPBYsg70BnX9AbjxbFFxx47ByRpp+bzuhScZj37+YalLWwBR6pfomA0i/
63Kia6jDcHbb6BTPM4llAkL7cs1zE/5LMM2hpXTS16QGDEQKcrPQNy9YqY/+nk4d
9x6/x5a0mDgqi5eTYv+N0h4VxFgEttdoZiuaLQOsXsTRMHr2pvVgzgb1dyP5M1yW
lUxc4x1QTPqTEVOjcvgVEJ0L0bcT5h5KCUOo14epYZ8Hd/fTfeMcOq7mkPPeY7Sj
Wzgx+2QEJVFYb3uJyBpZP5B3VsTTwAa7dadGwyv5YOu8bDzmOIqTLofLFbxZkv+9
lwXa04XKug/dUWG79yP8puBLXA/0bWpMEx0J5wYb6WLMLd2Z9pEA/H92ZStErI2z
HFyuHfBcXF0jvfFyNH+3u7jHRuquGktE9gbvA8kerHfDpDS6y4G50ScAm7sLjHAB
YFYDObKY5jdS8ymBQyq+kQc7AStBmEDJaWqq0RGclMIQb0fUqvdzfm3/mTz6lJ5K
mf6FrzdG5PyVSEHfMFNUzS/NXajypvzb1ia4XGVkuU1aisHuJIIweKRHsoiUHb/I
3GGPMe/TB9YGlRAOY3jb0MvLzYoBjP7LD/Bluewl/Vw2qRaJd4kol8M/RG9f+GQu
OrRnqLXyDGbanb5qrNeo
=Z0ve
-----END PGP SIGNATURE-----

--7UJuFtT020P8oFaEMoTxmTIhOSO4rH1lL--
