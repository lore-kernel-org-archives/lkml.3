Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3IZKSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:18:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33949 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3IZKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:18:36 -0400
Date: Thu, 26 Sep 2013 11:18:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Message-ID: <20130926101812.GD19304@sirena.org.uk>
References: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
 <1378988915-10539-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wLAMOaPNJ0fu1fTG"
Content-Disposition: inline
In-Reply-To: <1378988915-10539-3-git-send-email-g.liakhovetski@gmx.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: da9210: add Device Tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wLAMOaPNJ0fu1fTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2013 at 02:28:35PM +0200, Guennadi Liakhovetski wrote:
> This patch adds basic Device Tree support to the da9210 regulator driver -
> with no special properties, since also driver's platform data only contains
> standard regulator initialisation parameters.

Applied, thanks.

--wLAMOaPNJ0fu1fTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRAnhAAoJELSic+t+oim9xI0QAIZTkEKWBSXKdxZRQ0wO1pCV
cQPdYaIUKx+qbsjHt/yRW3iH9WRM2R0BWuJfEmUkXV87q4Ptw9saXmwPimXWNsIH
53TXGyxie04MGSvPla9d5VjJbE/k8IAdFGqtiMgL2OUCwKwjZU6DCdx9AEtOUaeJ
fZt7SqMEpWN6PC2wixke6EmUuUQj+eBSU5Y0cUZDs3QM1/qFbvkViKGdRwfOnZFU
2m7jHDLYSIc722yu4ZN4OcFj87PGaD6Yj3/8d7f+g5nVtGUCg/3Tib7hm8k/KSq6
x+XQ/O7yu4w12uuypnV3vXTMyjyRWz0Gk3dgtgbdt+bpAwj5xd/KkbYpKhUTSh/R
BWnng+d56JQ7WoqZuC9W/bSz9WGerztzGYwxmjQUKAefy4RGVtM3Zm5RJnCOfc3b
SYBsjgT4nO683yReM/ASSHIZ/QdEOcvKoWIxfj9ly1C1Bi5MH6bmtageggcip8qi
ChgzGixOqOUp+XGIcpaCk/BMW+eM5DnngRhVwFsfnMsvenJTN1Sro6Try12LGHsH
XL1ILtmp4ZAs9NzshNPGBeDXF92/6mpy0pjSVUeaIFWlobb14IHjZiAxsdFsqi0o
PsXWBYbt4cQtJ81frCbdAE+84d9ykgHk0Qg7YLlWynPKZyBb9w3xoTlYGhsYkbya
wOOjpCa6exmj2/SkaasS
=v/ZT
-----END PGP SIGNATURE-----

--wLAMOaPNJ0fu1fTG--
