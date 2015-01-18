Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbbARJ4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:56:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbbARJ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:56:29 -0500
Message-ID: <1421574950.31046.97.camel@decadent.org.uk>
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80
 characters.
From: Ben Hutchings <ben@decadent.org.uk>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        domagoj.trsan@gmail.com, dan.carpenter@oracle.com,
        roxanagabriela10@gmail.com, dilekuzulmez@gmail.com,
        daeseok.youn@gmail.com, sulamiification@gmail.com,
        aysemelikeyurtoglu@gmail.com, rusty@rustcorp.com.au,
        tapaswenipathak@gmail.com, sasha.levin@oracle.com,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 18 Jan 2015 09:55:50 +0000
In-Reply-To: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-njdwXf2lKnZ4rFAN39qv"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 81.2.76.188
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-njdwXf2lKnZ4rFAN39qv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-01-17 at 23:57 -0800, Shirish Gajera wrote:
> This patch fixes the checkpatch.pl warning:
>=20
> WARNING: line over 80 characters
>=20
> All line over 80 characters in driver/staging/speakup/* are fixed
[...]

It is not important to fix all such warnings.  The code seems perfectly
readable as it is.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-njdwXf2lKnZ4rFAN39qv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLuDK+e/yOyVhhEJAQo1IhAAhyuggs+iyv1rVCMN2GToBG9Cl2gPBcSq
hqrxKVGuzhGwYckEv8Qdqy+xCp7yjYtZXKCZIE8yUjOOfUkf8GKH8ogEla/oQ1OU
sGaXCZlMdrLCwaMDCirTXpmbuKwABikVUZYBJGtzHeTv4IHNOo+WTckKYuqOzsDi
UIgZw66pYV+Zg4i2JESAb8xbP+e09bt1LI9+rIsckjNECB212Z1X9PqqIO3NdGM7
qVXuq8jkfZp11fUP7ake/HOn/LTy5gD+Q0SyQvI8AIGmwou4nfrgAAS9rOZQ1Rmx
Avl7giZgZavYIilmtwvQ4HDFkqJQrh9jFXrPUZGoI1AYBRFMLwoy8bg155KRtLe8
eAHbIaxWph25xdtc3wNVHCeW3yXs/VCxLWSHB/FjnJJIjk8OkzDgXaXww3KVoz6Q
UbSq+h6JKl3JdRaLprV2xzuyBQxn3HbHKzizs0nAZg6TdP1+OjXgbYNsmxE6rAmD
uJJDonlk9M+r9sSPSkEMF8oJ3zJXxjtGcyMrSOIpJHpKegnrv2/2GEf3Ch8ldqLS
yli6jTFeNKmYMkp2vAUKrmTOrcCjsED631HSnWXaFAyxWTPsJ/6DlgDv2k4n/wjP
QZAi3ooKPZkrVqOzoKKBM/nNVyeTR3bvwnq8PI82/hQgtTO+x4Uyps9iufSdJ/cy
C+FIcM0FDvU=
=jVWO
-----END PGP SIGNATURE-----

--=-njdwXf2lKnZ4rFAN39qv--
