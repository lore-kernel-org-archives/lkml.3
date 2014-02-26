Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBZRkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:40:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40093 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbaBZRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:40:06 -0500
Date: Wed, 26 Feb 2014 18:39:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com
Subject: Re: [PATCH 1/7] Documentation: dt: iio: improve atmel-adc
 documentation
Message-ID: <20140226173904.GG607@lukather>
References: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpAOPzA3dXsRhoo+"
Content-Disposition: inline
In-Reply-To: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PpAOPzA3dXsRhoo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

On Wed, Feb 26, 2014 at 06:01:08PM +0100, Alexandre Belloni wrote:
> This corrects the example by removing the unit-address, as suggested by M=
ark
> Rutland in
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/23418=
4.html

I still belive that it's wrong, and Mark haven't answered my comments
on his statement.

I'd vote for a status-quo, until he gives an answer backed with
references to the ePAPR.

>=20
> Also, it removes the properties that are not used anymore, to stop propag=
ating
> them.
>=20
> Finally, fixes a few typos.

I'm fine with the rest.

Maxime


--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PpAOPzA3dXsRhoo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTDia4AAoJEBx+YmzsjxAgrCsP/3hu6rBDm+xElxr52vSVCaH8
VZux4UJvE3LtLj7Hnei3uMZbdFV0BHFx6id3Z2nbLEYPAoLWIG72nO1Cj6w5Jl1m
Fp75p0d/vY4v3Dy4Jz+Pf0yfaCEptaElLJO9YGGMyhP3i0i+zu7Vt+iYLLr0nJiD
h8S7XULzUlwzVvmjqNeZxDzWQ4RteSqRS5CvWOnJfAzF624Te9AhOS/gFRTBEUOD
cG9vMR7qM6g9fBZA6uXhGzY1nlyXJ70wIXOeZXzK8Xlleta3atZhora11INu984i
EdI9F1NcHswEov3eALZhIJghSczwCIs8f9XL6LqmYd5VDOqdOP1QwsxjmDVQA8Nt
E5lz6GIkYOFjthOT094WBAzlAkC7dkZCsXK0yjwDTjoYEW03PMyLuQ0y4cM5pBuf
gp0Dfj+aIV6EBrZbEsRYbnybpf5il1mznk2wEFrk93BknoX8MSnldO8h1GvPk+pG
/NQBfSXYUkLSBTCCyP3JfA/trZfOSHdbJYcSmEm1O8muoFWIHsGA3wFjn4zfAC8m
KCZf/40FZQeVPEsqIYKrw2N6pasYM0SfLwULk0qTXOhXAxp9Gts5T4AbKqaR7Jni
QRtrJjgjBL0mw4MoLQCfudsBqiUeTKEy4tz1+9MI67tBU1Kso5gpbEfyKMFVW0av
iZCqFdRWcISziMFkOMCa
=j/8D
-----END PGP SIGNATURE-----

--PpAOPzA3dXsRhoo+--
