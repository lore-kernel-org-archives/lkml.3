Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3EFWly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:41:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52392 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab3EFWlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:41:53 -0400
Message-ID: <51883175.8010001@ti.com>
Date: Mon, 6 May 2013 18:40:53 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com> <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2XIADUSPFQQCAIOPDKHKC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2XIADUSPFQQCAIOPDKHKC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06-05-2013 17:34, Aaro Koskinen wrote:
> On Mon, May 06, 2013 at 05:00:56PM -0400, Eduardo Valentin wrote:
>> Introduce HAS_BANDGAP config entry. This config is a
>> boolean value so that arch code can flag is they
>> feature a bandgap device.
>=20
> Maybe it could be mentioned that omap-thermal already depend on this?
> At least for a random reviewer it was not immediately clear why this is=

> added, especially since there were no users for it in subsequent patche=
s.
>=20
> A.
>=20
>=20
The flag has been proposed here [1]. The adaptation on the driver has
been introduced here [2,3]. It has reached the staging (next) tree. That
is why you do not see any follow up patch. Although it does not have
users at v3.9, the patch on the user has been sent several weeks ago.

[1] -
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101827.htm=
l
[2] - http://marc.info/?l=3Dlinux-omap&m=3D136335347305197&w=3D2
[3] - http://marc.info/?l=3Dlinux-driver-devel&m=3D136335404205514&w=3D1


------enig2XIADUSPFQQCAIOPDKHKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGIMYEACgkQCXcVR3XQvP1c4wEAk3fkX0Nof1JRgpeNjGNnbpqe
SFHC6EvXxjdon1tkT8QBANg72RQCIYz5qd6BgaHOG21iR7D0vu2t2IsvN5iX7+4K
=xy6d
-----END PGP SIGNATURE-----

------enig2XIADUSPFQQCAIOPDKHKC--
