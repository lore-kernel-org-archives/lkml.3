Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaJGLyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:54:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38452 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJGLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:53:59 -0400
Date: Tue, 7 Oct 2014 12:53:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20141007115335.GW4609@sirena.org.uk>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9FEOsnejx470nED"
Content-Disposition: inline
In-Reply-To: <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: Add ena_gpio_valid config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m9FEOsnejx470nED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 10:17:11PM +0200, Markus Pargmann wrote:
> Most drivers do not set the ena_gpio field of struct regulator_config
> before passing it to the regulator core. This is fine as long as the
> gpio identifier that is passed is a positive integer. But the gpio
> identifier 0 is also valid. So we are not able to decide wether we got a
> real gpio identifier or not.
>=20
> To be able to decide if it is a valid gpio that got passed, this patch
> adds a ena_gpio_valid field that should be set if ena_gpio is a valid
> gpio and should be used. It is a preperation patch for multiple patches
> that adapt the drivers and fix the regulator core checks for this field.

This should be part of the patch adding meaningful behaviour for the
flag, it's pointless separately.

--m9FEOsnejx470nED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUM9Q/AAoJECTWi3JdVIfQ8lMIAIPJm+ECWj9EsxbPagvLi65/
9rbcd3NVCTqbDv5nAWTTTRv79KkkpfEqrf5ayl4BtFEIN+4REYoaTcPYzyru7sKr
jNswl81XtkldlhIWAJ0yENwayV+qDn3Sthb2uBtCbYu9ss3Nx+ly1M7DmP479gua
JK4NWBiq4SdTpAUioZ0eZfydEwMe1ogh8QVWfHPfUTrS0NQQFKcgAeopInh2u+BW
qoS+GuvgHy0OZDuc1nSDGDE810EOurTqw60EQObHeNNj6525mysWv2HSGAcUOGlp
OqckDdqFY5EWUOH0uq2hR+DvOHn59BwKrj9i+dJF3G9H+dmaZJT5RRYWWzf49Tc=
=A2UF
-----END PGP SIGNATURE-----

--m9FEOsnejx470nED--
