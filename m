Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab3HNLjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:39:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37249 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781Ab3HNLjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:39:20 -0400
Date: Wed, 14 Aug 2013 12:38:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814113848.GP6427@sirena.org.uk>
References: <20130812214017.GH6427@sirena.org.uk>
 <Pine.LNX.4.44L0.1308122100300.26587-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UXm1vU+X4IBWGr3e"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308122100300.26587-100000@netrider.rowland.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UXm1vU+X4IBWGr3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2013 at 09:04:00PM -0400, Alan Stern wrote:

> The bus code would need hooks installed wherever the platform wants to=20
> do something extra.  This could end up growing to a lot of hooks.  How=20
> can the whole thing be done in a reasonable fashion?

I'd expect that we're just looking at hooks around connection and
disconnection here here - if we're looking at much more it seems like we
must be doing something wrong.

--UXm1vU+X4IBWGr3e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC2xEAAoJELSic+t+oim9BlwP/iGwqJazPv+JWHSoHPBcHwg4
VdzsIGwtxsJtRV5UHl/kYyDb4xyPqA7S3eT0MpLGs1EobaLEoRdXxT5PkxwrCpaq
NHnPHEcl9dNZcevIYqb35DeOvbiTe4Ywm4MMQvgtP6FlzH9m9gxrqEI2GfVJOC7h
RjBiY9A9TI2XqABB3So3yvB4wy09hyqmLwEJ97pZkIjnJjQRJKGcGrrZJnEN0GPo
HadgfCFRyI01XLb3b/0P7AnsqLXfxsPSpPSGbNJPShRvPMzwcFvhyG1SfQx551yg
svptPWdfVIWCrGBulDJX4oZh+8xFq1c+RaXHc4zZAkmi7i37Tl98vyy+M8sS5HdF
NZ+Q9tPpUi63vyxwy0W6u0GKk9JJxQ4wPKwV1h2Dijwa5tceDS8aVsEiceZxjjgD
cnrt1HIJLVXEykxCH2C/AIsB764UIj6Lh7hZhG7n8tr4IKXsngzVpSvOz2sL67y8
SMiwc2U29e7Rd7+pUmkDfkB6AVUU8OLmQ/2fEdNUhuUE7pI6bk4JDwA4xeBlVzZi
lHSEFhM++SCBGCgz97V7L2hM3NCuq0ZXRxbh6wvs+rpq44qf4oJSuDrrlHR4UGs+
V6yGh87p0xxYnpuJlTLQ+miSpEe0vRSfjotXbHNC5PVnl5sa0cdVB3nHJMzrcHFR
PQ01LHT3+IpvTb0szJwF
=FTrz
-----END PGP SIGNATURE-----

--UXm1vU+X4IBWGr3e--
