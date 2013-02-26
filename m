Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab3BZR7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:59:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41299 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759653Ab3BZR7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:59:18 -0500
Date: Tue, 26 Feb 2013 19:59:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH] fusb300_udc: modify stall clear and idma reset procedure
Message-ID: <20130226175910.GD1225@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 22, 2013 at 07:09:39AM +0000, Yuan-Hsin Chen wrote:
> From: Yuan-Hsin Chen <yuanlmm@gmail.com>
>=20
> Due to fusb300 controller modification, stall clear procedure should be
> modified consistantly. This patch also fixes software bugs: only
> enter IDMA_RESET when the condition matched and disable corresponding
> PRD interrupt in IDMA_RESET.
>=20
>=20
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

I have been trying to understand if this is a bug fix or if it can wait
until v3.10.

Also, according to your commit log, it seems like this patch is doing
more than one thing, which is really frowned upon. Please split it up
into separate logically self-contained changes. While doing that, make
sure that your commit log explains the problem and the solution very
well. Saying that because of a controller modification you need to
change stall clear consistently isn't enough.

Don't forget to mention how and with which platforms you tested.

--=20
balbi

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLPfuAAoJEIaOsuA1yqREyMUQAJhfM9DrAdIwUhC9pNu6aq2g
KblLDKRDSPPQMK/2AqRpPhk12pyGv8SEWBsWu4XKBAj1c1Y9zOUfcAOsA59u2wCq
b8PKDfDncr2ycRI5LulyQvp5C1bWDHlEiLnlmDNegS5kM6hdYJ68Dgl9MtzIYacm
IaeXt/b2Y2IiPN18N8ghntZael4KiRm04UuZzpcLKkx8qP26ZbMKaYx5merRx+aC
FVyqykVb2QW0XVBWodV8K3hD1lA5pfC3aPvanU6AeuoqtgDqyxAUSf1zTY3AaZ4I
sxzyDBp7LOyNT/9mGNrnLWbpw3x1GtGSpyJrzoqgd20nr4C+zgUzIfS49cfxB53/
5U/Au4ZEr5NJ/QMrjZ7/LIAQvXfT5P4ieNMz3W0MfmjzFm3Fw9Yd6+nttP3IsMHc
tuAm3b24SwUcxmhshX7CV1esQ9dZo0khJr4OOCVM9AjdiUrPLym3999Li2pAPuie
lUWE1pn3AYCTj71scxrpMuLL4kaGtroaas0BUJPodvH28NMpKmtpCbxOtNJn7SWl
OwOCP9uLMc2oiiNGguSkGs7hnh1GqzEVYrvBhwOp9W/V4kE/4/1Lq0oA7WbABFZF
vq966Gr+KIdDkrjRe3H4GU3hoqHF2gtRyLSq1LawTn5U3Vj9MKqbAJ7QhOqqpR8D
0wm/hJUPdV4aQuTYuK/k
=MDjj
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
