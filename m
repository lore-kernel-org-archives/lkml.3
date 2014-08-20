Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaHTPUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:20:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51079 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaHTPUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:20:44 -0400
Date: Wed, 20 Aug 2014 10:20:28 -0500
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140820152028.GV24407@sirena.org.uk>
References: <1408532246-10988-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jWL1oGPK2mPq0rME"
Content-Disposition: inline
In-Reply-To: <1408532246-10988-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 63.139.182.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Add ACPI ID for Intel Braswell
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jWL1oGPK2mPq0rME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 01:57:26PM +0300, Mika Westerberg wrote:
> From: Alan Cox <alan@linux.intel.com>
>=20
> The SPI host controller is the same as used in Baytrail, only the ACPI ID
> is different so add this new ID to the list.

Applied, thanks.

--jWL1oGPK2mPq0rME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9Ly5AAoJELSic+t+oim9lPEP/2uV0KhXTufFApjBXvF9Sgse
OwFSOOP3k77bEs8NwPOfJaduNHyfrfWfWrl5wgvBK1qQ94RERvmSN92MehnlwkxL
SyK0pZ823g6m+gEUXkdXOEiC9NrMQwnmY6Lab8KXGXXC4k13rAArCuFUOqm9/KyA
FfxDPYGi3r12700X0ycqPHMrPmqXm2l94nrmrLrbTFtDqICmse2AbnNSXnQPnUWT
CGD8O5xXDuNtPnoqW+OeYvvuk4E/jXoAB9nFhLM0ee07xeCBVHegX+lZ/zSAWwqt
loXqMGaELmVEJHNn3oa5BRIGeLSVFpEjU0zveQBoARD9oaRoLwzmHLBgv/YL2M7W
Byvgr78I6N+/wpNmudlEeHAvlrg3Rm9r6Y6ECCoouVmPpFhmNlKRciV+wC4D9nhv
zMYxm3eZXezYWOxYEQ2R1zmlaYqtn8l4Innk08pF94oa20v7sGHukFDLSLc3f62z
zHHxpm37++2dMIwbbpQORWZpmjPE4IUeot62cAYEI9cAitcOtSU6NBwi3tblTyut
D3Bivh86Sbk+blZNf0ot3stnsIy4PuxPJAr1SyVxSn9f1q8woReFIeONbvnGrFyA
nOllF4cu/7jnWwoYV6BMY/EuqjdgPilA9ZCwmxrCQOEnUg4DuxpaO+s7Jvw7Yofs
CdzaVNhsrPEgC58oqXtG
=8BZL
-----END PGP SIGNATURE-----

--jWL1oGPK2mPq0rME--
