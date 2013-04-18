Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967546Ab3DRRYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:24:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60824 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967156Ab3DRRYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:24:30 -0400
Date: Thu, 18 Apr 2013 18:24:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, gg@slimlogic.co.uk, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: palma: add ramp delay support through
 regulator constraints
Message-ID: <20130418172428.GO13687@opensource.wolfsonmicro.com>
References: <1366290168-3921-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8+odlFQADydc3R4z"
Content-Disposition: inline
In-Reply-To: <1366290168-3921-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8+odlFQADydc3R4z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2013 at 06:32:47PM +0530, Laxman Dewangan wrote:
> Currently Palma regulator driver support the ramp delay
> through rail specific platform data.
>=20
> As regulator framework support the configuration of ramp
> delay through regulator constraint, using the framework
> method and removing the platform specific data approach.

Applied both, thanks.

--8+odlFQADydc3R4z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRcCxFAAoJELSic+t+oim9wW0P/2NbOV/DQAEX3Vo33fkafTq1
yKoRmJRISjQh+QAZX8M/2swHsBwXPKasFB8UR192JC9vZpdkykZd0238J3QUGM6Q
3HqgvjfavzqH+gf/6TSCVikSg6CT5Jb58GK6mr66aaqDvI7rSIujASc/+w0rRV/W
wiR/uJe53qhvT1CRujOD+V9udR9N0L4BP616UsiHCE/9A/AsYF4rmnWPjXNMtgZG
jgAL2u1WyWo6BYZxeaaQhhouGleSevs3vnEpy7jPCOHbxx+lwE4XYYHFBBdecys/
pkZSFdVQD0T1M4ppOrm1/aYIs0+KSCDzqsuQO/1LGtozlIZVONTFZRcH32vQSoE9
8SQA4F7ewraAapMIy2pPb4vOUvkDGu9iS1LkJezmKALTofvSHu2cx0fRunD3ie3g
NLeU2hkjFPULQFYcQ6hKubkl9VcaeH8JIfiNgVda2WalNcSkwbxzfJbeiMXFPJPz
GgaXk5GS4yf20VEoagXJiAcp0SnrDLWvDp++O4Dwef4C7UQqVtrATGZLZorkyDJe
kNgpKQK+GgKLEUj/SnJFYz9KUrSR+ylmhbNUbtKfRvVohyHl1tXBgZXlce8FDEO1
8JecW1Rj9mbwU4qmThGcHd7Ow3crRiRY9of8X3+exG36xw8ebmKWYbyTPfaSheQ6
/ubqmQAFvzOFGwp6+A8D
=1LxQ
-----END PGP SIGNATURE-----

--8+odlFQADydc3R4z--
