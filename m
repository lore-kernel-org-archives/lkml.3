Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBNS0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:26:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46214 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaBNS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:26:14 -0500
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2014 13:26:14 EST
Date: Fri, 14 Feb 2014 14:59:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140214145908.GB4451@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil>
 <20140213111648.GP28112@sirena.org.uk>
 <2852394.5yIWXYGTNK@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <2852394.5yIWXYGTNK@phil>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.51.37
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: gpio-regulator: fix forgotten gpios-states
 reading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 04:34:32PM +0100, Heiko St=FCbner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
>=20
> Commit 934624d6e9f0 ("regulator: gpio-regulator: do not open-code counting
> and access of dt array elements") forgot to convert the recently added
> gpios-states property using the same pattern.

Applied, thanks.

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/i84AAoJELSic+t+oim9NSUP/R0DL/GTv/PNcFj/lQ4ZZQ8H
jsnVlGA4tf/SMVJqBkQ8X1KHW79XycUx1nqqqgLpGWTjMs7X8NezSCVEz+VxnsXa
dS8S5huqvsnHBgsm4M6GguQ8TFtlbaZW4P05lPDVswLyl9ObQtAbiTa3prqB6Jev
lXzsyFsoKNsi5lKSWOtsoqy2xCygj2abbOY0kVOJO9iJwX2TPx1VxZGJfmwwYWng
aPG2Gsh/LDZY8JPyKonXwG0b1SHxCKdgYIvbbmEpe+Tfli0vY2oo76X7hEqtB9um
wpGR6SDARb/H16FhpKzK0j5IZekLoDm3O60O8OE+xortqY5Xnxeiba/WDp4PyjCI
IaJx5fxdbGKTk2qiKkCGKTDrSXWXlRCShREuvuAIVgrKytJ22pxHvxmbE5dsref1
DMetHoAIh7rVP5unQ8oLPv6wzOwDhcM1xpanBt5cMnrp4UTjwLB0dLYzxCduz/Sw
UE3mZNYHK/ryqRuhu1VyfzhM9VGq1nqW51uNcRmlgR+qLrwAS13NQV6N7ehEtRqS
h0b2LnTTPE2eZI2P4MJuZQ07m3fxm8HEZltO+RkA8d3NjfcNug7AOpDZgnhNORnh
2a5i3dSBwX+etdqvIg0tlUpUvBXf7hE68cJSp0+VZpQ/epbfcgaVJSkqECwhPjj6
Fq1EasamNy31cTDUK0/s
=TTN8
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
