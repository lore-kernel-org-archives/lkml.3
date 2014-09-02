Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaIBLIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:08:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46160 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaIBLIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:08:53 -0400
Date: Tue, 2 Sep 2014 12:08:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140902110818.GT29327@sirena.org.uk>
References: <1409618851.4532.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hrnpeiJmytOBrElT"
Content-Disposition: inline
In-Reply-To: <1409618851.4532.2.camel@phoenix>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rk808: Fix n_voltages for DCDC4
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hrnpeiJmytOBrElT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2014 at 08:47:31AM +0800, Axel Lin wrote:
> The min_sel is 0, max_sel is 15, so n_voltages should be 16.

Applied, thanks.

--hrnpeiJmytOBrElT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBaUfAAoJELSic+t+oim995QP/Ai67stwZ7iqCL2MDfG1TLCL
HikdU763pk/HCNcjCO76nB3azZqCERvSICiBzaOvsKShx133SEBnxS9lSAJ8siOA
zPsOlHCLUCjMw2TRAqV0lK30se70P+WhluvbU0LtY8PxIEIJClSlxll1MthNhdyT
PQmP+Tit8m79yEmrSqm7Cz3nlfeNPm4j104G+8+y0hti2mdlvJvxzqfxxkUcNAAq
MFjlX73L/HrlqNQ0DUQqYgIehPwXCqX6rGmBHntE8DwOWEve8PXhZJ+YDd1uR0ML
Px6CHx7DMGxnyU/1tmCdcHRBNTBV9Yd5bQNjGPhIlyaTYSslEifXCvEjhNwBmzMq
OXHZ7IhzcbXeB9b6BlqnxuPp79X01r0F7RLMjceVNoe3/jwN/g2ziglKC7mcA/Fz
GiKPq6aHvPVbuZqPWg+97ev4BgA7CAXck4rlfOb9cUh1GqpAuJyMynd252pIlIbH
iSlpxuq4vETkNu2sBywhyED5wilE+rfzvRwL6K2/MA4V7bFU2L1UOQfauKF0JsWe
87LW5D93B7ydKzhyuWxq1+bmBXNo+uEWRFbj94c2YQPNrmyksD4jJ/vBPCbTOkUk
g9bK57M+w9qWIIaH/Iw7u3NjvzOG3xmRAZZ2zUUK+S1kWrr8R+HwJMjHXCyfZXDG
4eGfCiLPr2IvRYwrn9FF
=V+H8
-----END PGP SIGNATURE-----

--hrnpeiJmytOBrElT--
