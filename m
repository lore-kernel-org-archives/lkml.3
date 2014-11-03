Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKCQKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:10:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35685 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaKCQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:10:08 -0500
Date: Mon, 3 Nov 2014 16:08:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141103160838.GY3815@sirena.org.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415025649-8119-13-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bNvn4bxlrUVLu6cT"
Content-Disposition: inline
In-Reply-To: <1415025649-8119-13-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 12/14] regulator: max77802: Use unsigned int for modes
 in max77802_map_mode()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bNvn4bxlrUVLu6cT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 03:40:47PM +0100, Javier Martinez Canillas wrote:
> All function dealing with operating modes use unsigned int for modes
> so change max77802_map_mode() function signature for consistency.

Applied, thanks.

--bNvn4bxlrUVLu6cT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV6iFAAoJECTWi3JdVIfQsg8H/1bmFVxguNOvT8px9folEsWJ
SIIdYqDb3jdQGYxtdPc5Ls4xse9He2lGJs4PwqrsdJl+fjsN7sH+9qOiSMEPinRJ
w7PWs1pblnZC9Y3K/Ora/se7Hx7lxVGHh5AAIHm96jCDxu29MTQfoL+yHfPx0VxM
ccLssFRbjIz7GCxmPScFhC7H84NjgaencbR6RqXA/Vh/BcWSTuwTg2S6Ps/OmSpT
bddq1lBdrIe+sdjNEcs+yejvrUV2VmzrQEAkHBC5SGyQpOizq+RiaWgOez44BISh
EaMFfRNTKT3f9dYHM/aKEjDwWGaEpW3ZNgxkL+gVvNzi+1A2yh9Wntbhnhd3+8M=
=i9oE
-----END PGP SIGNATURE-----

--bNvn4bxlrUVLu6cT--
