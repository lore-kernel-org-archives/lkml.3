Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaKXP2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:28:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36869 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKXP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:28:03 -0500
Date: Mon, 24 Nov 2014 15:26:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141124152609.GE7712@sirena.org.uk>
References: <1416838252-15508-1-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Content-Disposition: inline
In-Reply-To: <1416838252-15508-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Add PRE_DISABLE notification
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2014 at 02:10:52PM +0000, Richard Fitzgerald wrote:
> Add a PRE_DISABLE notification so that consumers can use a
> notifier to run any steps required to prepare for the
> regulator being switched off. Since the regulator disable
> can fail an abort notification is also added.

Applied, thanks.

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc04RAAoJECTWi3JdVIfQiDEH/ROy7NT+PPsI9y28QdhBssz6
4Lz16lcKJI2cu7944hm3cwnzdgQk/xa/pfG+SBaReU28nwREtGpNczGRZevrOtXd
6Lk2mZX/f3NjE/6XOftK0rcVXr2syUXhBgFkQNto0njiDdtUsECgj6W8vlHPNxLb
E4TuHBwRIsFOBx11TJc9IVo3nMYVBoiD04m0diyGI4VcjZeMv2eNNN1zuAaXBZPU
KleoXW7dPf6OPB5FcUvav00UwFEf9Ofa6W5B351KSDFynpwcmI4Iwr04/GWu1SEr
ktVBE8NjrFuU0IIwkalDHnUfmERkNSiMe69uO39xP2Uh7AJm1dw0UYcCWbSSWqE=
=UjIz
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
