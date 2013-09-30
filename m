Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3I3UMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:12:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3I3UMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:12:12 -0400
Message-ID: <1380571922.15513.29.camel@fourier>
Subject: Re: [PATCH 1/1] Input: cypress_ps2 - Return zero finger count if
 palm is detected.
From: Kamal Mostafa <kamal@canonical.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, dudl@cypress.com, git@status.e4ward.com,
        tim.gardner@canonical.com, linux-input@vger.kernel.org
Date: Mon, 30 Sep 2013 13:12:02 -0700
In-Reply-To: <007c09ae4ef7f72ffb657de0fb3854fcbc6d88f0.1379968154.git.joseph.salisbury@canonical.com>
References: <cover.1379968154.git.joseph.salisbury@canonical.com>
	 <007c09ae4ef7f72ffb657de0fb3854fcbc6d88f0.1379968154.git.joseph.salisbury@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XkCwOR5f5Oya2NtwqQvz"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XkCwOR5f5Oya2NtwqQvz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-24 at 11:44 -0400, Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1229361
>=20
> This patch sets the finger count to 0 in the case of palm contact.
>=20
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT (KEYBOA=
RD,...,commit_signer:2/2=3D100%)
> Cc: Henrik Rydberg <rydberg@euromail.se> (maintainer:INPUT MULTITOUCH...)
> Cc: Kamal Mostafa <kamal@canonical.com> (commit_signer:2/2=3D100%)
> Cc: Dudley Du <dudl@cypress.com> (commit_signer:2/2=3D100%)
> Cc: Kyle Fazzari <git@status.e4ward.com> (commit_signer:1/2=3D50%)
> Cc: Tim Gardner <tim.gardner@canonical.com> (commit_signer:1/2=3D50%)
> Cc: linux-input@vger.kernel.org (open list:INPUT (KEYBOARD,...)
> Cc: linux-kernel@vger.kernel.org (open list)
> Cc: stable@vger.kernel.org

This patch works fine: eliminates stream of junk driver messages with no
ill effects.

Tested-by: Kamal Mostafa <kamal@canonical.com>

 -Kamal


> ---
>  drivers/input/mouse/cypress_ps2.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypr=
ess_ps2.c
> index 45b3eda..95b2c40 100644
> --- a/drivers/input/mouse/cypress_ps2.c
> +++ b/drivers/input/mouse/cypress_ps2.c
> @@ -441,7 +441,7 @@ static int cypress_get_finger_count(unsigned char hea=
der_byte)
>  			case 2: return 5;
>  			default:
>  				/* Invalid contact (e.g. palm). Ignore it. */
> -				return -1;
> +				return 0;
>  		}
>  	}
> =20
> @@ -460,7 +460,7 @@ static int cypress_parse_packet(struct psmouse *psmou=
se,
> =20
>  	contact_cnt =3D cypress_get_finger_count(header_byte);
> =20
> -	if (contact_cnt < 0) /* e.g. palm detect */
> +	if (contact_cnt < 0)
>  		return -EINVAL;
> =20
>  	report_data->contact_cnt =3D contact_cnt;


--=-XkCwOR5f5Oya2NtwqQvz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSSdsSAAoJEHqwmdxYrXhZonMP/0TqT97FU6VkspADyhuKMdgz
dJL0s67l1l+0G60LjweY4itv57N1oM9JU4xTi9zLhC/bm0aOz0SahopJbO5Tu89q
63gkDJIWiCsE4ieYp0QzNqeSw/RYsFMGP7A3cw4ulSJlfz4azyUx8chunRBN27/s
QDwxeJvppFUjuh+2W5CBF1xfs4FehfPP7hceap3BfvcaHE1UPQNdLmJpMkFtAFc8
ojzNn2J8Hxp4RopmI3p7geAUgb8yqHLd1ncc2L3QzZV2eMTW2ivBP1iayN6bAAo4
n3ATOpUdADYRv4JW+pUkqgTGGmf7VJVJ0uiekrw4+INrJcTducTOwoTv7dr/YuM1
lUPcRpjSyzC5BsTV9KbTYkEsD6nfxiDPJvLS0arxy3+MoOiRstSGUrSLpqrmk0Jy
8QdR8BUajB5g3wWXeGDmTFepSriGSM9exZmVg6KlvaF/hk1a+/kM4gjyxru5t3Az
5g4YQgi4s3UmPFdex5YLuedv5BU22eONU+4jvCcYT/v+sAXxmTRF5ehFV3GgGzn6
nGWgCv0Dl46C+6qc9olQfg6HLAxeWcKgTu9Sw3mRfIY0EY5f0aAVNJuBHgzePHI9
dT9YNipJMRWw6qRzy3jCtvpA9Ila1TsZ8R7DJ+FKmrR4/AaQuYbk3g2QBCmAQEWU
qAL00zNOcQ8UgvP+nLfI
=MJNC
-----END PGP SIGNATURE-----

--=-XkCwOR5f5Oya2NtwqQvz--

