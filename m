Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3ANOjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:39:09 -0500
Received: from mail.gw90.de ([188.40.100.199]:52928 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3ANOjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:39:08 -0500
X-Greylist: delayed 1755 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 09:39:08 EST
Message-ID: <1358172566.15057.16.camel@mattotaupa>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Mon, 14 Jan 2013 15:09:26 +0100
In-Reply-To: <alpine.LNX.2.00.1301132143310.1772@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
	 <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
	 <alpine.LNX.2.00.1301072206530.1617@xoschi>
	 <CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
	 <alpine.LNX.2.00.1301132143310.1772@xoschi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jsAGXu8HdcXbfEXbqb4L"
X-Mailer: Evolution 3.4.4-1.1~pre4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jsAGXu8HdcXbfEXbqb4L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Eldad,


thanks a lot for the patch.


Am Sonntag, den 13.01.2013, 22:00 +0100 schrieb Eldad Zack:

[=E2=80=A6]

> From 5817128d2761f60051b069d2bb31209c909b6a04 Mon Sep 17 00:00:00 2001
> From: Eldad Zack <eldad@fogrefinery.com>
> Date: Sun, 13 Jan 2013 21:14:08 +0100
> Subject: [PATCH] drm/radeon: fix evergreen brightness control regression
>=20
> Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f

please paste the commit summary into the commit message as remembering
hashes is difficult.

> introduced a
> regression, where using ACPI brightness control leads to a
> hard system lock-up.
> To resolve the issue, this patch moves the GUI_ACTIVE test
> earlier, as it was before the commit.

Please also add a link to this discussion on the list to the commit
message.

> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
> ---
>  drivers/gpu/drm/radeon/evergreen.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

[=E2=80=A6]


Thanks,

Paul

--=-jsAGXu8HdcXbfEXbqb4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlD0EZYACgkQPX1aK2wOHVghkQCdEYIgsbFsFFzpzV3FRW3oG2YX
Vr8An1tHlnYvWXb5x0b8iejRWdNBOMGz
=Lli+
-----END PGP SIGNATURE-----

--=-jsAGXu8HdcXbfEXbqb4L--

