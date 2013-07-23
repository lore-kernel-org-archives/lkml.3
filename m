Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab3GWRpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:45:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45361 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab3GWRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:45:51 -0400
Date: Tue, 23 Jul 2013 18:44:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <20130723174456.GM9858@sirena.org.uk>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
 <20130723161846.GD2486@kroah.com>
 <1446965.6APW5ZgLBW@amdc1227>
 <20130723173710.GB28284@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HQbpMUFNRY4iYVZ3"
Content-Disposition: inline
In-Reply-To: <20130723173710.GB28284@kroah.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HQbpMUFNRY4iYVZ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2013 at 10:37:11AM -0700, Greg KH wrote:
> On Tue, Jul 23, 2013 at 06:50:29PM +0200, Tomasz Figa wrote:

> > I fully agree that a simple, single string will not scale even in some,=
 not=20
> > so uncommon cases, but there is already a lot of existing lookup soluti=
ons=20
> > over the kernel and so there is no point in introducing another one.

> I'm trying to get _rid_ of lookup "solutions" and just use a real
> pointer, as you should.  I'll go tackle those other ones after this one
> is taken care of, to show how the others should be handled as well.

What are the problems you are seeing with doing things with lookups?
Having to write platform data for everything gets old fast and the code
duplication is pretty tedious...

--HQbpMUFNRY4iYVZ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7sEVAAoJELSic+t+oim9SUcP/ieysuGxUWbhqKHNUQJMzk22
s5EUHq9mXmZnv8GmwmuFlQZ3ntlWPuahPB8SUVgbwmCG8726u7z5qLSI+6RLPuTm
n1cTd1UqtKMpg3LlFky+4HaLE844ZE6fGxdQetxxDUj6D3YhENnPyqVOM+4qI9eO
9FpL2tZArEw1Ob0aFB8LJHL5t9zK2FFLyLqqa+LxctmgN71t/U8uiEXBwsqIxYVS
0aVhjm5L9FnnUT3uSsu8dznALPGUG5rkdWDe9FzMzyUpV8d+mn7iHHc8h8+0HNQE
EwtT9OrmBDORDVhq7QaRMejgKyCxTZKorqOB8Z1QmK5BBQZdsQE9Tp7nyFgHcqmC
+Dny2OE2rITlcpj5R/Q93Nv9r+0y/Uf4dOGymxzIMB/cbyAndxvN0EGOzKFvTU9+
fudz+arQaUOB29jxTN7vlnW+OSExX6zJ9uERObfOG+im8vagKcNvRok88hJOpC+7
4lEzcZzR5T4C2uvd7Se4YZylZeEW6TnWB9yMln9TW57u1DN5AeZuAimY2GEEc+AF
1/tvRfkNARDQmR5bianOpNPgDCoO1g+MuPyDOZYWhT/5bfuhei7Y5iy8+522HF65
CJLlQt9GMlSKcwjre8PS97jTcscmd6CXRxHqhYNowZlbhO+IT0zTXREHuDgCRvZi
Q63fF0aCpz1Y9Qh3iDYL
=K4vT
-----END PGP SIGNATURE-----

--HQbpMUFNRY4iYVZ3--
