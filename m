Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbbA0PKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:10:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44209 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbbA0PKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:10:03 -0500
Date: Tue, 27 Jan 2015 16:09:19 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Priit Laes <plaes@plaes.org>
Cc: linux-sunxi@googlegroups.com, emilio@elopez.com.ar,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: dts: sun4i: Add initial dts for Gemei G9 tablet
Message-ID: <20150127150919.GI7200@lukather>
References: <1422295208-11016-1-git-send-email-plaes@plaes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqSa+Xr3J/G6Hhls"
Content-Disposition: inline
In-Reply-To: <1422295208-11016-1-git-send-email-plaes@plaes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqSa+Xr3J/G6Hhls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2015 at 08:00:06PM +0200, Priit Laes wrote:
> Gemei G9 is an A10 based tablet, with 1G RAM, 16G NAND, 1024x768
> IPS LCD display, stereo speakers, 1.3MP front camera and 5 MP
> rear camera, 8000mAh battery, GT901 2+1 touchscreen, Bosch BMA250
> accelerometer and RTL8188CUS USB wifi. It also has MicroSD slot,
> miniHDMI, 1 x MicroUSB OTG port and 1 x MicroUSB host port and
> 3.5mm headphone jack.
>=20
> Changes since v2:
>  * Fix syntax error (brown paper bag release)
>=20
> Changes since v1:
>  * Added sun4i-lradc keymap
>  * Added TODO note about missing IRQ pins for bma250
>  * Fixed formatting issues and removed external URLs
>=20
> Signed-off-by: Priit Laes <plaes@plaes.org>

Applied, thanks!

Note that it will probably show up in 3.21. I sent the pull request
this weekend, and unless something major and unexpected shows up, I
don't plan on making new ones.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NqSa+Xr3J/G6Hhls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx6ofAAoJEBx+YmzsjxAggF0P/2+5OAqz3mhEkB3aciwtMZ5a
bfOY+A8J+kuaNaeQJp6TPIIATv157hntiFMzE4B/tpLurMG9b6aYz755/xkXcifO
nmBgQ2HwC4LweKRxoYePKTc6T7TJ5YqUpW7fSOc9Fjfw8lLRy+Lnv8pnJPtfyCIj
GEuqH472yNE4C3dJXb6anqjn+lCTzt6FtmdDxIMDQEUc6iS4BqMBDo7Kn68XWNfe
Ey8QRu5cCRm5UScJ0VvZ55l5V19Qk40XiB6g5J2KntAZHPviKgqdWb2GlO+lwajS
+3/1ixoD3p5eMSQsoJG73rILwTQalVSWPMbLLvL/tkveo1DyPJy9VvCNh1IIDJ4u
qeefLobHuBwJOYIv6Boo5Qg0L3K3YglpgW4NVemtjbrYu3K5sg3Mf5maDj+pn+tp
To5/E7H0esDQcFVr9KVMIsL9MRfdttZ8LLBRywus9SV98KxiwSxC8qGKeMpID8TB
fSoIImv8iTcI3Fw+eY4Bz5dzhzciYc/rA1IR/3QRxDAErUa2RzrNoMc2oP42SEOe
lmH+/8uWuZBYv0H9ocPP6caqpBpsU2d2YD28efA+Uj6SS8oP8FjJISpP/zzGqxqz
YU8AuNeNhYP2xoM2j4e08sbD5oH+t7ZIml09eAsecDCMa9y8a5NozcVUALukLe17
KrZ2KMwu7QFm9aTbh8a5
=nMam
-----END PGP SIGNATURE-----

--NqSa+Xr3J/G6Hhls--
