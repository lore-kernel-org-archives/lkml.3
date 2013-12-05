Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab3LESRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:17:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37862 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3LESQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:16:12 -0500
Date: Thu, 5 Dec 2013 18:16:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20131205181606.GY29268@sirena.org.uk>
References: <1386202994-30784-1-git-send-email-robherring2@gmail.com>
 <1386202994-30784-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQ6PUHtvLgXN2OhJ"
Content-Disposition: inline
In-Reply-To: <1386202994-30784-2-git-send-email-robherring2@gmail.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] cpufreq: enable ARM drivers on arm64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yQ6PUHtvLgXN2OhJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2013 at 06:23:13PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> Enable cpufreq and power kconfig menus on arm64 along with arm cpufreq
> drivers. The power menu is needed for OPP support. At least on Calxeda
> systems, the same cpufreq driver is used for arm and arm64 based
> systems.

If this needs any revisions (I'd be surprised but...) can you please
keep me on the CCs?  I intend to pull this into LSK if that's OK since I
was about to do roughly the same thing for it and upstream the result.

--yQ6PUHtvLgXN2OhJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoMLjAAoJELSic+t+oim9VRMP/3QLSg70vtKAWvb9Fcbqn5xy
GRwsUuIwlcGT0YZ/H/9RhTvikNkjkU1qu2twLM9XLA7ptA8lof/ATzWLe2EBXQHr
EpfD65IZU10LtiCNXfecfF5DU6HP7XhQt7taqYofMCdny1U6s/xNYZGBqxWSieWl
TKzCM/bUCyODE4SIE8YsEutnzszReXFZoQKOmIOsKfqzJzizH7cPiFR7mBDwYxlU
f2KhH5bleAwPx21JHfRruB1R6pQz1cHRav0F2bnWQDLmjXtiijTVLse8iiIWfOd9
g6Xe+suVknKoOCz1j/eckgqy8mrnm8dfPmqr8ftpvjGnSHIoeJ621YdhEUTL+96Q
MsSzbaoj1kQF8hUyeulNVtTQj4NrNL+ccZNFK7OEenMICeuJQJehQSYC1MThGRt9
AH/8Z3MGYk2rALEfPZuHDUNXeB4Fhc4TiWdeMrIYJHQePDmzbSxsoYth1J92yNjh
4lKv2eSwfPmn6xNfcKma218fqSOzYYnY7D25ILoOr9U34psqbUanollla8mlvd2H
CQjJ7PjclACDAdx+XXxqaSQ1oF/0chO0gD8qfPFdN10fQu9ocGsSwgcNLTEyllgh
U32IXRy4+I9cklyS5JK8rprOFy5OUJAwVmAxqfUlMvidrWYal0Pdh4FdH+XDmuX0
fpFSbeqHbh0QNeh556fA
=dXXF
-----END PGP SIGNATURE-----

--yQ6PUHtvLgXN2OhJ--
