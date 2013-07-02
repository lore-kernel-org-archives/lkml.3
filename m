Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3GBPtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:49:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56087 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3GBPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:49:52 -0400
Date: Tue, 2 Jul 2013 16:49:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130702154925.GR27646@sirena.org.uk>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702093247.GY27646@sirena.org.uk>
 <20130702094404.GL3352@arwen.pp.htv.fi>
 <20130702101718.GE27646@sirena.org.uk>
 <20130702104338.GA5107@arwen.pp.htv.fi>
 <20130702110432.GJ27646@sirena.org.uk>
 <20130702151947.GD7013@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4MYbgvGoS9GHC/6/"
Content-Disposition: inline
In-Reply-To: <20130702151947.GD7013@arwen.pp.htv.fi>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4MYbgvGoS9GHC/6/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 06:19:47PM +0300, Felipe Balbi wrote:
> On Tue, Jul 02, 2013 at 12:04:32PM +0100, Mark Brown wrote:

> > One thing I really want to get round to doing with the SPI core is
> > providing an easy to pick up GPIO chip select as standard=20

> that should be fairly simple I guess. Just lack of time, I'm assuming ?

That and all the refactoring of drivers required to adopt it.

--4MYbgvGoS9GHC/6/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0vaCAAoJELSic+t+oim9VC0P/2NgzbSZELo8W8N5tK6bkCUM
Em2hWX/C0DgoXER+7CaKKUKHIcblkNEMkMdUGQOiNf+I8FHZ8TjbES652d/JdW5h
ZzDpIIGPjMPgK6BftKs9aVd99RRWKhJ2mmqAEoIJirwiZUdNHX5x9MR9AXIk94k1
ix1cDV9VIx7p3RLaaGxXQtzgzAZuymS2kj4AxZtcaBx72hJa4PXvjTxcvSGzFHCN
NHs+CPh+n6Ic5QWYWehboM5zy0Wx+/vauxRw8AJ6304d7t76aopx7YOCxST1V/MZ
9llZENnAesY86Qabte48XNoN9rEsniElOaGJthlrvBdWMjUwr6OtQb9Bhbe9OQEY
uKhyz2Z45JLWQ6ahanCgcs9y4Rw00v3iyo6km+pNFBbMEuJG7htTLxS2GHSNRDEC
DequUwpejvdKoxkSJ6hE/KcCPynrImu5/Ja6AzUwJ3LJzSuJVSSu+Rxj1KfzcZmL
+8JxuwL2HDm7pJYVBEQ8/4RvAIUQgvgMTVOy0YYYyIndHPaNR6xWIiLBalux4w1q
1RqNrYaqgsO/9ie1Ei0EccFsGMH0Zd3O8aaBGePQS8jkb3XlxjA56wpEZT5UkyNm
sgVdomEMbT6QblDGYpm+8KpOOoMHPHmPx8kMAabjcckqN6FfR2XYRz6CMtjdKhGL
FC3gh42T8bp27VFD3W5W
=vA5d
-----END PGP SIGNATURE-----

--4MYbgvGoS9GHC/6/--
