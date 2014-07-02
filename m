Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaGBLjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:39:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGBLjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:39:16 -0400
Date: Wed, 2 Jul 2014 12:38:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        "Wenyou.Yang" <wenyou.yang@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140702113854.GH410@sirena.org.uk>
References: <1404113529.21614.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Content-Disposition: inline
In-Reply-To: <1404113529.21614.1.camel@phoenix>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: act8865: Remove error variable in
 act8865_pmic_probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 03:32:09PM +0800, Axel Lin wrote:
> Simply use ret variable instead.
> Also remove unneeded initialize for ret variable.

Applied, thanks.

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTs+9LAAoJELSic+t+oim966AP/1XeiY8l7mJI/p/ifoWnLShm
2xh+NWl9cH+TbzmqPJpcN9ej26Y5U3HQ2SX1Cu92gIWAEWuix+VmPXzMB8lwLM5i
0buk8zDt+wxoh5evMyXhvIH0j9FkItxd+tO2sAq8HvDvEeMYHRAcBqZPMjzDmjCY
gTBgtMnCX7sxYnuMOjSz9opAOzGbeGW5Mv/AlWDFhc6hEUPh1hxpZKP4Gkp+Sd/W
rmIxBuCY5455/fG45UTARIqVvVqTM0sJxqjp1lVY2GkAFbrWB85h+4jrBK4cQWK1
s2aXsBeXuGT04bJZ1+tzFOZDWH9KT12uXIkwOTnBkTfD5wMExhOOPIBHZhnqr0+W
caSYq7YK9DBzJurk0Sd0uP5PRB1nCiTWtpoSsGxcITmzlAA9xtJVrxuEe6el7ZKN
ZQ4q14vsoDm8mwvn5lP/lBugnBB8upXp+BcpTGEl7aoUFHw+U1RYW+MGskD67Aa8
nrqqMXwUZEFwhuJk1uVUGaGBHeuuE8lRMWGcV8H943yDCfzSRNxl8rxn10YrHLe3
TW5LigRdzYHje8ZPbHH/J6zzrjCE0Aj1IpREA25Tk75pXWkmh2iSdZXinRz87RTW
gYaC381BzthiOr3uKsyhUNIxKe7FMnDFbqGvkJH0ae8YfJtSDglZHvQ8uNLswuQC
0D1UaYSH0NK3tLfivmY6
=OGBh
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
