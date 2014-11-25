Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaKYVUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:20:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38570 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYVU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:20:29 -0500
Date: Tue, 25 Nov 2014 21:18:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141125211826.GR7712@sirena.org.uk>
References: <5474E91E.6000401@metafoo.de>
 <1416949399-29718-1-git-send-email-olof@lixom.net>
 <20141125211431.GP7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7b/njLcpB6QT9MFH"
Content-Disposition: inline
In-Reply-To: <20141125211431.GP7712@sirena.org.uk>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: provide dummy regmap_exit()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7b/njLcpB6QT9MFH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 09:14:31PM +0000, Mark Brown wrote:

> I'll tweak the commit message when applying.

Oh, on second thoughts Lars sent his orthogonal fix so we don't need
this for build.  Given that I'm not entirely happy with that one user
and don't really want to see others I'll skip this so we catch any other
potential users.  Makes sense?

--7b/njLcpB6QT9MFH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdPIiAAoJECTWi3JdVIfQ4f8H/2YqJYW3ZL3mF2Xr0Gj8L3Qy
rIcIMuWqHGlM+u6L4Bh7bkw30eTnwf14mnrvbZ94eRF9D7PJR/RmITY0JO348vi8
kPKUp2Hk54EKuRWsCm5LJtzTSS7Jdq2IirxCMhWRaHDhoA0EQwMee9ytn2sBnIjl
G5cHGXTvAgTP/uA3+ADvWbD3rId3YUiWEofGSXa4aGqCb3ybu+oWzBEeGgCFvA2l
SUdOKJsADpoVLEswxNBDtIrUmn0//XDx4KWtJlaZYCtjgCTc6Dg4y9S/xc42v4xp
50BpT3ZaSB0GJVs0/zalumXk2Qt729XojJ6mbEftKznlCP6fZ7smZr51N7WKDV8=
=asbk
-----END PGP SIGNATURE-----

--7b/njLcpB6QT9MFH--
