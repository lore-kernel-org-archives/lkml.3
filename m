Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3A0DTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 22:19:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42146 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab3A0DTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 22:19:53 -0500
Date: Sun, 27 Jan 2013 11:19:42 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com, anilkumar@ti.com,
        tony@atomide.com, hs@denx.de, lrg@ti.com, sameo@linux.intel.com,
        khilman@ti.com, linux@arm.linux.org.uk, rob@landley.net,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 4/6] davinci: regulator: tps6507x: add device tree
 support.
Message-ID: <20130127031939.GE4650@opensource.wolfsonmicro.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
 <1359024920-32190-5-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Content-Disposition: inline
In-Reply-To: <1359024920-32190-5-git-send-email-manishv.b@ti.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 04:25:18PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> Add device tree based initialization support for
> TI's tps6507x regulators.

Applied, thanks.  Please always use subject lines appropriate for the
subsystem you are submitting against - this is not a DaVinci change.

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBJzFAAoJELSic+t+oim96WwQAJB8HnZ8Rv+Uf7+0fqlbErUR
+fbTAmGjTWLIVzmy7VPsyonvcKb7KvsTEpZoqXJluiLQjD3gvSqB8U5ZJ8QrocRd
QVk/DZG52fug+b8lC8TTf++kxBuk7y8KdFfNifLip29C2t9Raq2Vu2dprVEBZvXY
GemGNyHRb7FgmogaDjDxGeJDQHeDe7xzpGWDjmlyIvrzhk36RrLNSgh/LuCXarS4
HUB/NWHOM92OD/O32dSsJU+uW+SUJQxygGzYry5jMxhICizE1cZyjglhqtRpD30U
bFGUSqXUYh/6SvJlOJ7Kjal0YONBdzipz/v8LIWO8A4exl0nm27nSLtmvp7MY9KR
UQxfHcu3wAcRmPzFKW5bMvorz9xXhk9cLDqWtQ9xCDKUgkddSB82iynhuV2yerl2
abDPy3HuhhVnIJKHXwfGRBHZnfphwlgO3RryC7UfFyYSrIJbqNUwDM6FtlV+XLjw
gtIvlhi07O3aqjPVnsP3g56vLeBntrr5GcTwZ1qipFEBo3EtF+gcAcIQ455ThtfJ
+PjN5vu0cP6QLaLk/lHQ7GJs0H1n8mbKJuCF73+32Jwf5/mN0RwkQbKfMx/ao3Hu
2FGM5YqcY/qX56EIa4UrJouQHw/lL/DX9apsOMkSNPwkrKDD0mmlp7BDQyra2WY2
pC0W+SgVoMAe+m7TvRXh
=nVEc
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--
