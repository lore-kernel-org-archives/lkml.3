Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3G3KWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:22:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48392 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3G3KWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:22:00 -0400
Date: Tue, 30 Jul 2013 11:21:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130730102136.GL9858@sirena.org.uk>
References: <1375152388.4265.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMqrikAAFIpDiJk4"
Content-Disposition: inline
In-Reply-To: <1375152388.4265.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: pfuze100: Fix n_voltages setting for
 SW2~SW4 with high bit set
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMqrikAAFIpDiJk4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 10:46:28AM +0800, Axel Lin wrote:
> Current code adjust min_uV and uV_step but missed adjusting the n_voltages
> setting.

Applied, thanks.

--oMqrikAAFIpDiJk4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR95OtAAoJELSic+t+oim9KdcP/iTmH766WwdTOderKjFS1AwY
cuxmkUGSyNK1KyDGNsJMdOmMuegHk2+u1pYPQHRq5C+L/o1k5bw9N3ZcL0wyLu0U
grFlk8Qp0AAKuXKvMP9xCC2jcorM5fl8moGf21ezpE4f8D9JFE4A1wLZoLeZFhkl
Jj9oRPmszAALiDehyMwSyHYm2OpjiFNFJaiFOH0fPSlS3Ed+z7jx5GCZwqAfSA4a
/onrMaUPvQ/JQxyBixlRHZHFDW42YPeya9tDHsRn7NiMinzt71q1BV7eQqbvqpIl
j4aq47m3CANX2HWzSlep1jJHZUnXPO1ozkEhFlbmsiY0YawPjbe/0eaFC3gxHzvi
mBN4hPlyoMXxPqXhIaKQJ4DW57uA8Y7AgQgXS2mL+nryKZakQ1utq1yEYbWoPsQN
T3G8XO93p1aX6qLtX57POCR345zqWvJKX2dfVRerQq2WV9gKVA3F67WAlhUj49Ej
TP5odpQ8aY5zff6ks9hS8dQbH8SxDDkpDQmObCjvGSIS/7SVz5I6KrR+GNRkrapA
ZtLFo53NCPxbYJTmkifbVG7a/aqc+PAyQ2g2zTY+q1Xcxy6Ay4Tv6qF195hy+R1D
hxcCHs2mEWdQuag9FQM3RqYm+rMFn5s37qRtAhPb6FHA6tei4fUb+Bn/WkcMkgkL
CuFE7Rk6+HzSjbfaEih8
=uoz7
-----END PGP SIGNATURE-----

--oMqrikAAFIpDiJk4--
