Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCJKMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:12:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54432 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaCJKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:12:40 -0400
Date: Mon, 10 Mar 2014 10:12:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140310101232.GQ28112@sirena.org.uk>
References: <1394350032.19772.1.camel@phoenix>
 <1394350339.19772.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZOkuavRWyrLNW3dO"
Content-Disposition: inline
In-Reply-To: <1394350339.19772.5.camel@phoenix>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: max8998: Remove unnecessary **rdev from
 struct max8998_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZOkuavRWyrLNW3dO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 09, 2014 at 03:32:19PM +0800, Axel Lin wrote:
> Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.

Applied, thanks.

--ZOkuavRWyrLNW3dO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHZANAAoJELSic+t+oim9r2AP/RvISAXkRoxlgkBe0p33cT3u
OhFPwWIGFn3GHd4853e4az3ymsoaVAP3NP12i62M47ZOk3hB/VPwVIbC+xro8TIx
JTkOFCcSP+9DXPYSq6hT4fhQFrz1ctUmBrapSEB632GMkU15vTguVNcj7lM6Ftrx
30OlyOVpCP2KlCszON9W57I1EenRuank7x6qX2Ni8YaeBWsNi7rKKBxNE42ftOrv
AcICLd1guxfmfsPOrN2xw/Knt3xl/hxA70TGX8+G5r0pABzl4RC0PUYePMUe9wNR
h6Strj13d8W00Rd7bdlBaTJvm76rY9EsNmmr7v9ACYpdvT/r5cdYkdROdJxLzH3N
pAMOvn9nVuG8hHJM66rfbHjMJXb1inj+dPqPu+CLJVJ1KAAx9I54ckycd4yMQFXs
DXN1nJCd/zKbMc+rRIiGFWmsacrj+C1NhKfLIN6DBSXjCYjTYG0ju9fKD0+n65bu
pn0E+Tx1U8rqgLYgCOrz72F9tDj9SohqPFKACmEUSG1IHsx0GC5v75tP7L7TsOVl
mn/D+FDFNCHOLEdKg8OMbFB65Fm5LlrTIBCBmAvMJd3Z1W9JlNq8Zh0rPlWJI1xO
Uy1qPNA44yd4vnB2klA2FQKdZvnDfsIRLJkXmimH2VUeGDo8GPWezBhwBioN9RxE
mHfq7MeE/1y1WFZHLEs1
=ni5q
-----END PGP SIGNATURE-----

--ZOkuavRWyrLNW3dO--
