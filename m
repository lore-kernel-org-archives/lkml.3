Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3CMLN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:13:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56162 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab3CMLN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:13:28 -0400
Date: Wed, 13 Mar 2013 11:13:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Expose total memory consumption in the rbtree
 debugfs entry
Message-ID: <20130313111326.GM25610@opensource.wolfsonmicro.com>
References: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4g3zIzscEHdx6fd"
Content-Disposition: inline
In-Reply-To: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I4g3zIzscEHdx6fd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 05:26:49PM +0000, Dimitris Papastamos wrote:
> Provide a feel of how much overhead the rbtree cache adds to
> the game.

Applied, with a tweak to the log to say "used X bytes" for clarity (it's
arguable if the cached data itself is overhead, depends on what you're
comparing to).

--I4g3zIzscEHdx6fd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQF8zAAoJELSic+t+oim99ugP/RJ7C2gY+aFr6nSMtsyGnBKS
sN0Rf1J+rDOD50C7a4552l4kXR5jeNyF/8ENVaUU3BTkga95sBZuL4VLtFIbhdIZ
BLH7ymuK2ERKeI3OxH2aaUtO0jCkWSwik0VoZQO4Pjlfo85Mzq/FjtzeKfCOpX8W
xXuyngIATJXL6gqI1t4EBqO+YJdNzfp3wdvztwzSmMM5fW6NWMD0WipWNFmL0FeB
f26pkyqelX/0ufJ4diTmbOljSJa89uNJCfZEhBtiETVCim6hyigj90kARe2SIgiD
Nh3ZBAtD1Iqd6Ob3N6mDXirr+fHL57cl9o4w9krSXvnATEMLiRPrMTfTJ9O+FZH4
SoOH4lYwaJ/qdLY0FA35tY1tq/ydn/72mVNpGspV0390d/jtJgpXoqv2p0eGTkz7
1x5POgv2qE0t/AUjx03IJ1WSZmuPDbr8g+jeEYBDFm5AMh6PP4jula3FxqG3MKgH
MRrC3klBLqrNeH3LBCEFrzKJ2XWXSLL/MEcjg2hBQkH3l4MNTmeQvTx/izicbl++
PxAMimNLrpbF1yM9I8jHQTG5f1ro/QZg53TlNBcPlENSIWpis4rMW3aQS1CzhnqF
sOnCtcFxhTwk5uPdmqDhW9q3m1ipeA9bcIbyi5midewUCrXvSz8uN63020fH5cBV
OOtcjSI66axw1pGvoaNI
=MeQV
-----END PGP SIGNATURE-----

--I4g3zIzscEHdx6fd--
