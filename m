Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaCFJlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:41:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56767 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaCFJlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:41:35 -0500
Date: Thu, 6 Mar 2014 17:41:29 +0800
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140306094129.GP13126@sirena.org.uk>
References: <1392806653-29604-1-git-send-email-nhcao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OZBeERS9UGv+teaY"
Content-Disposition: inline
In-Reply-To: <1392806653-29604-1-git-send-email-nhcao@marvell.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] driver: regmap: add regmap_parse_val api
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OZBeERS9UGv+teaY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 06:44:13PM +0800, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
>=20
>     In some cases, we need regmap's format parse_val function
> to do be/le translation according to the bus configuration.
> For example, snd_soc_bytes_put() uses regmap to write/read values,
> and use cpu_to_be() directly to covert MASK into big endian. This
> is a defect, and should use regmap's format function to do it according
> to bus configuration.

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--OZBeERS9UGv+teaY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGELGAAoJELSic+t+oim99h0P/05Cm5ePGx28ZUeF9B8KJBMy
c2fQOZ0QTDWnSjfza2UUjiuavxU5xHn5bokNvEIna7JY8thu6/vg+nB8q+Auz5KT
hlVi2EBVHoRQO5G1DLbzEpoYnNqPCu2YsfHxh5wB2szQGbguI7JxeLfkCLjeO16d
dNog0E0O6rs1BdBvb6TAHfqsu2jR+aYlHK4zS2uIzs1WFWMKAis8oHR50/ErNv+K
dUhFyJZyHb0RNTtpOzqN0jtqU0vsEKgOhvovWRCLO1T5wzmHyQf+ez1ro6LUXPGY
2PfbvsZjxGK0RsDQgh3fpasBaE3yOkUdgskOzx9693JTIZ/gRNe87hiyhaAT+dE0
qRcRk9WRxmZmowxAOALYgjcM4F5n+y4EvSI9WeGlEXg+15s9B88LlN2a79tOlB/O
bcQck08/ftP9tVq+PojHyXRUvEU/iOckT6IXR+NhnyZWtloUQCS38F8aRb3zpCDB
bJfrUImuGshPK6Z7itOQ0BBcSt94B2EcfXnQcvme0qNBrUXtyOuyxHhVXFf7/1cy
bttcumwow03dPqBfhYYBcrC9c19v68qeKK/d1c6jyYViOrXVXX1COXCHJn5c3+d2
ys2+OTP4FBfdNDZR4JX2inDACAFWZTeYiEk9WNMZmCBQ3iXlAmGJv2bujNrhz4Bj
JganHd3uH44UzpAXt/ps
=zuNo
-----END PGP SIGNATURE-----

--OZBeERS9UGv+teaY--
