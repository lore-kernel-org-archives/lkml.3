Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaLSLjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:39:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36567 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaLSLjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:39:47 -0500
Date: Fri, 19 Dec 2014 11:39:30 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, linux-spi@vger.kernel.org
Message-ID: <20141219113930.GD11764@sirena.org.uk>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
 <6486956.sOFTSHEqBe@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LN2Nay5amKJRgrhj"
Content-Disposition: inline
In-Reply-To: <6486956.sOFTSHEqBe@vostro.rjw.lan>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] spi: Replace CONFIG_PM_RUNTIME with CONFIG_PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LN2Nay5amKJRgrhj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 02:49:26AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> A couple of new CONFIG_PM_RUNTIME users have been added recently
> in the SPI subsystem.

Acked-by: Mark Brown <broonie@kernel.org>

--LN2Nay5amKJRgrhj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUlA5xAAoJECTWi3JdVIfQ4Y4H/i1QIBvQ50DxVv0eqtUe9MWs
B8PMhsx0QdGtBy6/ySOaBUBugG2c/jYukvEN4XV9OJaaWnQXr9BPONdwNxynBsl5
mm42eIQJxAvZnBUN0f/O1fTjbR8y9dJ0zqcnLj3SoNAEItwtvb8IIxXlyUGe6q/j
Ksqwfv9NuPrUE0ZVvgx1VTaF2Vag2OMm2KRplZyPwPUu+MXpyoxWQert43McGYL2
wI7gGO8g6Iudi6slUThI6imgHmfCCW9Scokf6qGbYY8tDAgzD6LLkTr/N4Lwafb7
MaZp7dJERrG7fnKQEYyNsAQ2jhIzfrs8BvBwMGa/rHklOxUlbFr9wqYnUkSCik8=
=dsLY
-----END PGP SIGNATURE-----

--LN2Nay5amKJRgrhj--
