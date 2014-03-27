Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaC0Rwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:52:37 -0400
Received: from sauhun.de ([89.238.76.85]:41697 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbaC0Rwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:52:35 -0400
Date: Thu, 27 Mar 2014 18:52:31 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: omap: fix usage of IS_ERR_VALUE with
 pm_runtime_get_sync
Message-ID: <20140327175231.GC11379@katana>
References: <1395937113-10222-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1395937113-10222-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2014 at 11:18:33AM -0500, Nishanth Menon wrote:
> we use IS_ERR_VALUE to check for error values of pm_runtime_get_sync,
> when the value can only be < 0 in the case of err. Replace the
> check with a simpler < 0 check.
>=20
> This fixes the coccicheck warnings:
> linux-2.6/drivers/i2c/busses/i2c-omap.c:1157:5-24:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 1158
> linux-2.6/drivers/i2c/busses/i2c-omap.c:1278:7-26:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 1279
> drivers/i2c/busses/i2c-omap.c:638:5-24:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 639
>=20
> Signed-off-by: Nishanth Menon <nm@ti.com>

Applied to for-next, thanks!


--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTNGVfAAoJEBQN5MwUoCm2RsIP/3mwwJgWLpQUFnEkgPuGZdus
53YlHaBF1hBT2ziO+TYQg44/j3oU4uzBN64ImJYKTRZqGwsnT4m9Yj+bkOJFXwKr
DSqXMMAmojApJr2bXt3iSMUl8vD0AEGKoLWvEY9QClVo+Mb5bHnkoUlBQZSRRquN
QAH36aLCsJtFz/1iHGzQCY/UAQyESK9x62KghgKFVoRegYNqOcr6HK/ed8OJs4J/
F7iXe8EVXIcinS250/nqEtpzBbfAcZE8TKd3EOLpFI2785KzK7Q+N+DGp8tsmQJC
odXXcUPZ4Fk2ZNeQ+lZxl8LCo67wNvGS5LuLrp2SGDJgrEWEWcvMvsfKByZSGqLX
hc2q//ioYneapURLvBSdYExCstBtlZs2ozsAI94Nsdr8evUgU4ixKlNr9AmyWjhY
FFHzdGL49MvY/JOSte1HyTH+QgJIEJgxtXPZ1kyEM1YTIMvfBtVX1Q3ecoarkG0v
OwOUYDV7OJsJgIq1MKl2dKmItjzVzoyJ12K7X82Mze+58m7XQnbssrPllctBlKc0
9YuxzB8kOBHZWWfxkLtFCAhCkRmw0+Ff9S3QYF2xZCagU/7XfpS6T0wZkY3oT+GR
0oYu2fpsJZFczxXwnxZJO9jVxkBY+BJ9FLd/B7GEJAaiEtPtx7hAXaBL4MonJcEn
EuMLcHNripvta3mVE8bb
=ARtt
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
