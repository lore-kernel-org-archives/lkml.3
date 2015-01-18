Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbbARKyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:54:12 -0500
Received: from mail.kernel.org ([198.145.29.136]:36832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbARKyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:54:09 -0500
Date: Sun, 18 Jan 2015 11:54:03 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] power: bq24190: Fix ignored supplicants
Message-ID: <20150118105403.GB11147@earth.universe>
References: <1420447908-4389-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1420447908-4389-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 05, 2015 at 09:51:48AM +0100, Krzysztof Kozlowski wrote:
> The driver mismatched 'num_supplicants' with 'num_supplies' of
> power_supply structure.
>=20
> It provided list of supplicants (power_supply.supplied_to) but did
> not set the number of supplicants. Instead it set the num_supplies which
> is used when iterating over number of supplies (power_supply.supplied_fro=
m).
>=20
> As a result the list of supplicants was ignored by core because its size
> was 0.

Thanks, applied.

-- Sebastian

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUu5DKAAoJENju1/PIO/qaygEP/35fzlaFXPukzaXdJ3ifxHzQ
/Ik7Ur+DUAKnl3STzOi6XW1RraNM5v00yCB8wrCdoW6fsgk7aLIzj8v08Encq/Ku
/8jncC8s2Au0BdFHiF7xkDO76KncThZoJ0smpNqPtVyHoMT+EuDm2YeZXbFKeZYK
OuCUC4F6GXWAJjaETF6t8Ntf1bpS5fh9R5A6RhAa9E78zR63KMCi74wtpMM5uagU
JCq8iCdBwcheILaeTBx/cFj5F0+feeqiEsKBbfmvh2DO/VV21XxHjWt3Ku/R3CDT
Ux728KSE8MKJprB7gxD/4ZiTIgXv41bkw6BxOkcpfJPZ/FxMVZGtBmCeUc55drAy
lee35y6JJ/WN0CX9qqHa9HSFovIPQI5hNSuL5SWLSqm5G2JlpGq7lQWo3TOfe/T7
ffsHizd3BjHQ2KHQqwnVNeByUXMmm/43WgqD0yitMiLKqoYo2UZuzdnzo0Yt76UT
FRQ1AkTJo45SILSHQGTrKQn1Zh17zFotybqt8P3qKMldhPTmktZFb0tvLompamMS
JhKaf+CaPRfkS8K2erdnQ42Rs09L9TNc4YpjGPyskRW4OuyLp8CYQsUSR/L26gB2
YmJUisEpxNeUh1qaxZwZrvjcSOrhQdvUAzx0uXHwQ7L6Kt1LQgzuypEQhdwpqRto
VnJts7ggRRhpqXIdG1Nb
=dJz+
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
