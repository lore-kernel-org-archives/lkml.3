Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaJ1TqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:46:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41862 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJ1TqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:46:03 -0400
Date: Tue, 28 Oct 2014 14:45:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Albino Biasutti Neto <bino@riseup.net>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: Errors: Compiling 3.18-rc2
Message-ID: <20141028194532.GK25735@saruman>
Reply-To: <balbi@ti.com>
References: <CA+bYFQZ2T4XPVhnZzfB5yWt6J11SDWf_5KzguEX0VZqmkVxYhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HBg0C3yr6HVa1ZCc"
Content-Disposition: inline
In-Reply-To: <CA+bYFQZ2T4XPVhnZzfB5yWt6J11SDWf_5KzguEX0VZqmkVxYhQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HBg0C3yr6HVa1ZCc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 05:41:53PM -0200, Albino Biasutti Neto wrote:
> Hi
>=20
> I was compile kernel version 3.18-rc2, very errors:
>=20
> # make -j2
>=20
> fs/open.c:822:1: error: expected identifier or =E2=80=98(=E2=80=99 before=
 =E2=80=98<<=E2=80=99 token
>  <<<<<<< HEAD

looks like a merge conflict annotation. Are you sure you didn't have
merge conflicts ? What does 'git show' return ?

--=20
balbi

--HBg0C3yr6HVa1ZCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT/JcAAoJEIaOsuA1yqREbLIP/3S8OdVdhdTQxTMjJGrkSb7S
P0nWSEPnJ/a6c0QCSdMYlLyNZ0CElBwrlV0ldNn4GvlRyAZ/9Y2NXae/bmNXESlI
GeJdgBomslLYYVEEgAjWPuEV9X5JBVXAmPOGxwPHPu74eDO4qGeGHSNrcaLWzkOK
EJ6SAnZvfrzeSZtqY/RNOH01Y+v676jV4J+AaJxzoZFz5ZwwFEuqq1XcFNHRS8vX
VggawDOf97t/7aneJdMQCoHBsHfHEFqHvEO/L2HzXP1W8KN/kCmku6nDsrc6reSX
XXUQ/OrkI6ZhCSMfSmcQVb8o6Wftx4ic5a5gJCYhD928+pikzoIU9wBUCA+3+5Tw
jYPpNI5tDKpCeIOTivIMVdct5m5y+aabUue6Nv1K7GneQO8xRDScl/a93oA6VT02
QjpJLfkXyuZ3/BY3HaiVDAFDxrB6z/Xp4sXis062oAosfWegSKeMilyf/MMbthfd
DWsi1flhgGiKTICdVpCHhgM/qojIESYfLuH2CNEpbIM9XrnZbhImM06smE2keEM5
P1fFpqECKO9gChHbXPjkjUyMJ6l4gLyh1f9juMZBut6izUIIJs3I5kloFJMRmo5u
bCBRvqK/VgMfKDfukvwZKdr0pVMqaB3ca68e4wiiF9J90t3PC/KMxwxPDdSBp8g3
mksJSOSbT8KghiEpV9Ak
=Fmj6
-----END PGP SIGNATURE-----

--HBg0C3yr6HVa1ZCc--
