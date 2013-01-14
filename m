Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3ANQwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:52:11 -0500
Received: from mail.gw90.de ([188.40.100.199]:53256 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab3ANQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:52:09 -0500
Message-ID: <1358182303.4675.2.camel@mattotaupa>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Eldad Zack <eldad@fogrefinery.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Mon, 14 Jan 2013 17:51:43 +0100
In-Reply-To: <CADnq5_N+pHZ5ugCDp7EfdW7yZ-ABS3M-vk_xtUFmnqDzz9sBvg@mail.gmail.com>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
	 <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
	 <alpine.LNX.2.00.1301072206530.1617@xoschi>
	 <CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
	 <alpine.LNX.2.00.1301132143310.1772@xoschi>
	 <CADnq5_N+pHZ5ugCDp7EfdW7yZ-ABS3M-vk_xtUFmnqDzz9sBvg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PtkEGVztCRzHCWIIFBrZ"
X-Mailer: Evolution 3.4.4-1.1~pre4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PtkEGVztCRzHCWIIFBrZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Alex,


Am Montag, den 14.01.2013, 11:08 -0500 schrieb Alex Deucher:

[=E2=80=A6]

> Date: Mon, 14 Jan 2013 11:04:39 -0500
> Subject: [PATCH] drm/radeon: clear reset flags if engines are idle
>=20
> Fixes a regression

please describe the regression.

=C2=BBbrightness control hard system lockup=C2=AB

> in the gpu reset code after the rework for DMA support.

and add the corresponding commit, Eldad tracked down. And for
completeness the URL of the discussion.

This is important for distribution folks to judge if certain commits are
needed or not. And for users looking through the commit history to spot
a certain fix.
>=20
> Reported-by: Eldad Zack <eldad@fogrefinery.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

With the above,

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

> ---
>  drivers/gpu/drm/radeon/evergreen.c |    6 ++++++
>  drivers/gpu/drm/radeon/ni.c        |    6 ++++++
>  drivers/gpu/drm/radeon/r600.c      |    6 ++++++
>  drivers/gpu/drm/radeon/si.c        |    6 ++++++
>  4 files changed, 24 insertions(+), 0 deletions(-)

[=E2=80=A6]


Thanks,

Paul

--=-PtkEGVztCRzHCWIIFBrZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlD0N6AACgkQPX1aK2wOHVj1FACeLTZGQPkU1az9AvQmLH6sICCC
zf4AmweEgyy0+VQBVnWG9AGXhupl/ncz
=J4SU
-----END PGP SIGNATURE-----

--=-PtkEGVztCRzHCWIIFBrZ--

