Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab3JPKkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:40:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47202 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab3JPKkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:40:06 -0400
Date: Wed, 16 Oct 2013 11:39:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131016103942.GG2443@sirena.org.uk>
References: <5253A17E.10503@nvidia.com>
 <20131008090910.GW21581@sirena.org.uk>
 <5253D489.7010900@nvidia.com>
 <20131012121412.GJ2443@sirena.org.uk>
 <525E17DE.6080301@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KmlZJfNsL65MWMNI"
Content-Disposition: inline
In-Reply-To: <525E17DE.6080301@nvidia.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KmlZJfNsL65MWMNI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 16, 2013 at 12:36:46PM +0800, Wei Ni wrote:
> On 10/12/2013 08:14 PM, Mark Brown wrote:

> > OK, I think the device tree board code just needs to set full
> > constraints during machine initialisation.  We can't have multiple

> Hi, Mark, do you mean we can call regulator_has_full_constraints(), but
> some platforms doesn't have board file now, they only have dts file, how
> to call this functions?

There is still a board file for DT machines, it's just shared between
all machines - it should be doing the call instead of the regulator
framework trying to retrofit it.

--KmlZJfNsL65MWMNI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXmzrAAoJELSic+t+oim9OEYQAJTH5wC/05ElIw9Rwef/lF33
vGe5/4T802bkyQ+XdbIf0iT6FA05jfYYgYsr7oG5u0diQTNTbLtTo4pQmhrtRZRk
ZMVAbmfFPgJspXY5wKO6C2ieVWaOcGkmJKleTVpnAqpQ9GkYnFyQZoE5S1sMgBR9
QeZl2vl8Asrs08w0oFYe5/MuzVemX290hZfka24OLICuNg5VFKe6IAkxraNhBDMo
/ECYWjWwBuBqMEJVVT3S8VRDO8HTnWbC2R3X9Z/uglN1qljTbz8gTNNLjhZLP/kz
7ePbgCSgzDAWfGkDTMVascpB196SUdlSnC2g8OcIi64mXm2ybiiatlstSojWJsX1
1ruORbEp9qmnWQK/sKSgKuccK1EenlD4D5/E6cLM0q5wgr9NH3AXH4IwGxLhwUU7
tLGv7pnrjyVpBnr3utARq2Apr86t0bO5V0InQ33JxdJOjz+CSblVnSMOQgwNaqgi
wOJV1mLV54g/YeBZIwReD4ZMFyNoTleqiSy0VmImSNcLxyjgav9CmrUpCfmQOgCn
53K5uxpXCYuc5HwqbDGULQT9QQYCQPdmnxaI0TEZ5zu12Y2FdtsGMpTuPFb8MwMZ
3SqXlVb7oz2kwiDcTdmhwXZnZQkGcMtplnWmv1g/z7AIMKgKlf1UvH4KQIGs7Q13
Dp//3Rm4LxllMj/8XGwC
=P38b
-----END PGP SIGNATURE-----

--KmlZJfNsL65MWMNI--
