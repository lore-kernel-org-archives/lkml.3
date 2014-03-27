Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaC0Qy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:54:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48548 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaC0Qy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:54:58 -0400
Date: Thu, 27 Mar 2014 16:54:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140327165445.GR30768@sirena.org.uk>
References: <1395936479-26069-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0Qexx6XJGNEACt6j"
Content-Disposition: inline
In-Reply-To: <1395936479-26069-1-git-send-email-nm@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [-next PATCH] spi: omap-uwire: add missing iounmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Qexx6XJGNEACt6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 27, 2014 at 11:07:59AM -0500, Nishanth Menon wrote:
> This fixes the following coccicheck warning:
> linux-2.6/drivers/spi/spi-omap-uwire.c:485:2-8: ERROR: missing iounmap; ioremap on line 471 and execution via conditional on line 481

Applied, thanks.

--0Qexx6XJGNEACt6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNFfMAAoJELSic+t+oim9EswQAJn8hxOrJsGbRmB6tqTDHytd
npYyNyUL9FsrsCtNOEUIoTHFAACD3lZbT/YNB5yUft8UdHPiWHDOlqc0qtW8KopC
gyFnz7QyqTHKWx0369pQDy5qtgaLmXxG1ByuR9VJ0zMfLYVY7fz0ZC6h6KNIivcb
v6NjzY4YFHudc+oC+IERkWZ09ZYtSPJVJHHwuva1rBZB3RurwCLmUQfF4FxBWOSX
SN+fk2mWHItbexvqQzYa/MO/HNvMNlEvHKrC5gvAxMMI3Dtaar3H9Gv4YvGJUho1
VqJent+7NQn3c7S+n8npJd4fvV1pJZ8YQxmKepwhgK2DvXM8BahgjombcceGX1h1
7ulNF19cLUrc2Jr9Fc5S2KLBEusFPMaGRLmwhPd8XSu0SSucutQaBNWdLU+PefAF
jN/hMu8p0HFQTHtxXFOIDfy1TyA902daUQLD2UqygfaIaufY9yO80PM5Cen+E4jW
KUz6mvKZi+VLYGnRXwI4Pm+xjgTDDr2LkOqKQWMygeUY2rRaDraqlL/tLGARIRzn
oumK0zjmZmvbkc6Qt05hFY9FRG8q6yfDaIAXLkek96ofjNjqqB6WJofNn9BCvVNj
IZalabqgH39OdhIfbZwjaOnm+oBVSxhL9+Q1D9vCg4JIsl3hnIlCPBKZ98YP+iwh
KVeJHNW+73hoRjHOS1s4
=/VZO
-----END PGP SIGNATURE-----

--0Qexx6XJGNEACt6j--
