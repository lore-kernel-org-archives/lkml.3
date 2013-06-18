Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3FRP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:56:13 -0400
Received: from sauhun.de ([89.238.76.85]:45718 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab3FRP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:56:12 -0400
Date: Tue, 18 Jun 2013 17:58:12 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/2] Fix kernel panics with certain I2C tps6* chips
Message-ID: <20130618155812.GB7718@katana>
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 08:47:35PM +0300, Tuomas Tynkkynen wrote:
> Hi,
>=20
> Latest linux-next head (next-20130617) seems to have some backwards-incom=
patible
> changes to the i2c core, which breaks the tps* drivers in our boards and =
cause
> panics on boot.

Thanks for pointing out. I am going to revert the commit in hope for a
better solution.

So, this series is not needed.

Regards,

   Wolfram

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwIOUAAoJEBQN5MwUoCm2KeoP/0SXp2lP5JGUOYMThaNHig6o
CXN11YqjaTxgaWLo51fwlnY9hMVj1vzkh7QTze2hMWbPP3UGAULJOyhL6uMD4kP+
wOVmOrKqKOH0iwWON2gMuZ3CD8zDuh98gEk6GcmYv/fG+4RDZhTKPQSPUjoZ+Pic
A8LRDVfVyw+6YTqrrNQkNHv3D/hBcTTgKate2wTn5pLq0UzXPY0isP3/knIB6HXd
VITlbnwZH55T2N5SiJ9ZSoM2Qas416CXhAKBv0TZjxXRgIyrwjmKbZr60QkSCaX3
dqguGsCJEq9wDJRo9eayT1N4mXA/6xyRq8HNzchha6tvOwgKWyTmipciywREfq1E
ilW6o3jFzMgYCqAtBmT5cmR6Mwgj9MY2gCjfWBsqqIBt3604rGbk+VeQaofAd9lh
q15gUDb+5mBljRmHWkv4c6T7e8QXrk42HY9AcPjvyeHvuh0AKyelRX5Gt+uj8GA5
FGWVBD404yrvY4OSHHHUTw+XhuIdd2GasnFDiJFoMg8lPYvO9YT+sFFx0Hm+tw+u
P1Bst0o01aFmtALbCJZHldjjZTiQPpy+QpodtAm8nr/5oIyUpFKUxbN+DHumILng
BGwoESdqS2+zqN+E/BRqRJitIxCWBs15uzB0Vkf+/AugcsAAGJduYPfqBl9dYPJ9
WQcMNfzGXvyFJ3lznE8D
=vt/X
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
