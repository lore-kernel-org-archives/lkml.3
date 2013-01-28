Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3A1VBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:01:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3A1VBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:01:44 -0500
Date: Mon, 28 Jan 2013 22:01:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
Message-ID: <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de>
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com>
 <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6NWzmX2ZMbypSmRZtXIBETTGDB79bDVKVc3xqesnJ8E
 J7zTLQod+DcOIV3K6cUlx/j0ODuql0gvJb1Ic7GP1ScYIlWqMr
 k2Vjk5XCE5W5xJGqkA3fZs7QKryb3eMrOFZo7AspO7aD0lMyne
 plB6IHrnRwlChWzMPlNd8W1oAHyt/8ZPV1MXEVlWzyWdQAYAIP
 nnUTziRFt5xdgSkxZTaGBdIKdiWOdJ9ahSre0JAOL5jIjXbTvV
 ioN3ahqkn8CpA/QqplyZ09VR7bhQ24PnTi3hgNgn4vCYPgnszq
 OmsY2Q2jaKGLNmQ/UKTlVHQg5hSusLMPIR2RJKB5gkYkUVKmdo
 IlPmO77sWYQXpaMxUuOUDbfRUP210vBIjK2QG5ROArjOCXz6sA
 HmUG0puugSjQJC8E/w1Tm0PMdDElY88HgUKzXzpAPSq/y7U3wP
 HdQ4H
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 02:39:53PM +0100, Peter Ujfalusi wrote:
> It is expected that board files would have:
> static unsigned int bl_levels[] =3D { 0, 50, 100, 150, 200, 250, };
>=20
> static struct platform_pwm_backlight_data bl_data =3D {
> 	.levels =3D bl_levels,
> 	.max_brightness =3D ARRAY_SIZE(bl_levels),
> 	.dft_brightness =3D 4,
> 	.pwm_period_ns =3D 7812500,
> };
>=20
> In this case the max_brightness would be out of range in the levels array.
> Decrement the received max_brightness in every case (DT or non DT) when t=
he
> levels has been provided.

What's wrong with specifying .max_brightness =3D ARRAY_SIZE(bl_levels) - 1
instead?

Thierry

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBucjAAoJEN0jrNd/PrOhEuQP/2BwJc9TCZOAU1uXwodzIzR7
hAfK8+XXT7oWiUIajw+XrRumNEVItqkT13LrxVGYRoWBpOJLvuVs7LmDOwg7hfu4
cNLoXeVslmZWdZL8NjRPF2RcZL/M5Hv1nFf9vQiDzw67MhrpMwpICYY/52UrhJcE
N4y9wmoF8btANoVEHpQFnkXVjBfUYPoQLUt9veMNs6VQlnMkCE4E0IMocoiokCfo
oxpseZFtJz7srEgGLkBYWfcmw36wO8cWF03hW+YugPYq48y7B5HKp7o/VDuc2QHR
bISVXAWN1qKLKNgPWPd393wBG8BE0/18lmennd632++ng3wYSRuh3N6sBhqug6yZ
ERqjh8EnVQh1dipcA2zSl1Y3sDRrOZLnEQrNH50OhkpIWGbGAipmbEHCPhQkS/Qn
ROCt0dEAKd1yY64AS0dQgWpuptWTghcQ9gxZuTyiubt6IviV8KT0abO/1aFmuGVK
fiHMK7yyocLyWEXRad2WaPgR2jdXDDN817d/8mzp2WRkBFXs+8HIB7Bazh0G9buV
ATspIkc0b81eEu18AwnGlAHpFNPiTbA2mjHZ8goGSTnstmnWaOGDfTrUcGbwlmcx
Mowqt2SlkAli4Pl8FwmmXi5GELcnpNL9CdXimsrVMkdy8P89pOPmrXUtOKZrYNRB
6fBuAxeQtvU66j1tuVjx
=0Jdp
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
