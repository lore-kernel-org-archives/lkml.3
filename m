Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaKCMEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:04:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35219 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaKCMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:04:33 -0500
Date: Mon, 3 Nov 2014 12:03:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Hugh Kang <hugh.kang@lge.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        jonghoon.park@lge.com
Message-ID: <20141103120313.GC3815@sirena.org.uk>
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
In-Reply-To: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: adding disable options for
 regulator-always-on and regulator-boots-on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:26:43AM +0900, Hugh Kang wrote:
> From: "hugh.kang" <hugh.kang@lge.com>
>=20
> If a regulator is set by always-on option, the regulator will be set fore=
ver.
> For example, suppose LDO1 is set to always-on at RevA.dts with including =
of a.dtsi. After that
> RevB.dts may wants to include the same a.dtsi but override the LDO1 alway=
s-on option. However,
> currently there is no way to delete the always-on option, even when we ch=
ange the LDO1 option value,
> the always-on setting is still remains.

This sounds like a problem with the way the DTSs have been written - I'd
expect the thing to do here is just to move the property to the rev A
DTS when rev B is created.  Why is that not the way forward?

Otherwise this is an issue which affects any boolean property in the DT
so if it's something we need to fix we should be fixing it in a generic
fashion that will work for other properties too.

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV28BAAoJECTWi3JdVIfQkisH/ietK/XHMdE5XElgR1tt6TPn
ktUsKgTD8Bk81a0V2qPQqtQ1W5G8ZLAQbOx42KQuhHGiA1HcNwKUJDP/VxibIQ8J
cJfqynWvpuKQmnsjNKqFt6df0xtsNDHHDrL5PBauCW76Ao/uVyfaHOaahU5P5Qbs
XuobwSs2U1Fd8X8IRtOk6saU5BinEes9D2safsRExt6r11waRADV+sp8Lgmu1eCl
+zHG3EjfJOiCIy9afzNNoNd+m8a5ViXpxytM4t8Kbiduw4DdF/6A+Gvgm+61LU68
+j8UexRblFklub7f+kvWCx74oZdSaJXX2ppSyKJlersi1WiZka2DhBOCdqdpxE4=
=xAP/
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
