Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaKCP5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:57:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35634 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaKCP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:57:05 -0500
Date: Mon, 3 Nov 2014 15:55:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103155535.GU3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-8-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y2illNFYgwJwqOHD"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-8-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 07/14] regulator: max77802: zero-initialize regulator
 match table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y2illNFYgwJwqOHD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:40:42PM +0100, Javier Martinez Canillas wrote:
> The struct of_regulator_match is declared as a non-static local variable
> so the structure members are not auto-initialized.

Applied, thanks.

--Y2illNFYgwJwqOHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6V2AAoJECTWi3JdVIfQYowH/RsrfESOK0DyJChzf6Bmq8Q/
cft6eW8s2grX0KtVjQz865NK9lb5RjjawpGYnvJUNCyYYJq7zhQjy2SJE7MwCod4
6z294KnmSFwCN0fERzoK7PQGM7XU/pep6RoUBNS5ImC/vLjLKW2iyPVdIQRNU75J
UigElqT3amoHYA0/L6joB8Mc1wciuGXRmMrwNPCHankMkPMzXf6Bo40NIf5ahmJd
q+cZTKvCii1zSuzVgeOpbNytp5UDek1l47JmJiW469YGbB9iqs4JaVQHgGFir5XU
4U0jNQECc2LGMSdajsmxleYgYnm9tuJGj6I5S5stNPFAgwKDAok527PcURsp++U=
=3gp9
-----END PGP SIGNATURE-----

--Y2illNFYgwJwqOHD--
