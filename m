Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3GIJOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:14:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33723 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3GIJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:14:49 -0400
Date: Tue, 9 Jul 2013 10:14:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Message-ID: <20130709091416.GN27646@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
 <95fea2ecead16435fc526b1d7f36a0a1ec1635ff.1373290150.git.michal.simek@xilinx.com>
 <20130708145119.GJ27646@sirena.org.uk>
 <51DB9F03.3050203@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pRIGWEjU0Bw92Zdr"
Content-Disposition: inline
In-Reply-To: <51DB9F03.3050203@monstr.eu>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 4/4] spi/xilinx: Use of_property_read_u32 for reading
 value from node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pRIGWEjU0Bw92Zdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 07:26:27AM +0200, Michal Simek wrote:
> On 07/08/2013 04:51 PM, Mark Brown wrote:

> > Applied, thanks.

> have you applied this patch?

Yes, network is spotty here so pushes aren't working so well.

--pRIGWEjU0Bw92Zdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR29RfAAoJELSic+t+oim9dyQP/2zCV9M1s8C+KRDQjBOA1LBD
8P4OR4DGZWoku0CZEBNbMR9bslleHcPo+8m7/5kFF3Bg7HPneiYPs8gIgGv1dicE
zP93Y7MBM/EKrIecPRf1uomaIcqbgD0Q9nSqU8j3F1ERcoshFdNrnTcaJHI9Asxj
Bh195itiyZeU1kK5jAqQrhh34ETT+rPJRe3Yu4CvPtjTESDJhVwzO7N4y7tL25JM
iLMmcFQc+hXs/Xz8y0vqF2r+qfIOwZvAgC5LPZjJ4flU4urZ/9LM9cu5NkitzaFx
rUPGv4NI2tjTKMuwW5jqcsUVniFf2t8mip+yeaDAQ7Pu5CkNRdATgWHAbPvEW/JT
r4o7fg3jtCH8BbEoHl87lb9vKQebhaKSA4Wlot20IiNCa5sH1PiF1lIQ4Mq/Q8BS
QF8LX/qYPXciPHU0BCamdUPeiVdE5bPgAKo+AJ+PGh//uN/YKWwERzDpNagAxY6d
de5aVgEcSLLcybbXTcndQAKmNBAczMG2WT27OZtfibrN8skJCi6nHltTWrajEeHu
A/jwF20gaNsA7a1SH6KQqS8Tmlap8SfXmGaR8KiZtUeK1UYrAjefRlrPJnksxAgs
MJOacuFtVAeGHoKbxmA1Ub78oZO/iQeWAoxN98tMePSMUJ/uwSi6tcDrcrg8nNdf
vhtrLC5EdLRHMPKcNhRn
=ojdQ
-----END PGP SIGNATURE-----

--pRIGWEjU0Bw92Zdr--
