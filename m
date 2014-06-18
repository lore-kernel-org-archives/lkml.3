Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbaFRJKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:10:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51657 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965516AbaFRJKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:10:16 -0400
Date: Wed, 18 Jun 2014 11:08:30 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 01/20] serial: 8250_dw: Add optional reset control
 support
Message-ID: <20140618090830.GH19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:38PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A31 and A23 SoCs have a reset controller
> maintaining the UART in reset by default.
>=20
> This patch adds optional reset support to the driver.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToVcOAAoJEBx+YmzsjxAg814P/RwIShFZTzaxNxq0PkTDL4+2
8ZwE8CBWnRrkMNKK7MUWEiwVDaBzZxHIAVWJylNvitLZmigKhK1xRqy2QVMJubo1
19yQG4OIrItTG5VI/zzqNb8EftOOIjy197TGCoiK6t+mIQuH6QvyZOr6DUfQtN7W
OvUbb0YceAG5B8uA5Xm8LUkM9EdD5Hug8/ctIDX+x8jQbLJ8vwlwj7po7NtC7iy1
qnliimLEawnYw+rne6DSIvxUg4SL8T/N6pSGqQ2CEJj/ttgjK0nEszszsZzPRnMw
WmjocIeBpofcHEjXawNua2OGI60RMu+NcDv2kLr0xSM5HS7iaadvCwQUOZybSp77
zMo58/YpEtAlJljGTO9q+UBGbdwI3p/f4d+oyf6PoxjU1cikTL9Ct20mXCqrl/+7
ZJ221j5IQW/sGpv8GdhimmRQQ5vjhhT50wXTbF9g83yIadb+Cb5S6R61+WswQukv
TigDxpraoVzey5mVUm4IIyIl1J5elNKo7qf4SPBsFgeS3SVrgVK1DJKQuPB7B+9N
x/CJfsLJZBgn4e13CBOrQK8d+Wnw0sZ5YtVyrLTsSoxxIeQVdMRRf7CWndD5asTQ
JFhIxjAnso3f5vPdbJ7FjXp3WEIK5bb8OSWuwks4qVgj9uJof/OXyR+b1StMIwEW
mDu01xx/+Z+aEtyoOjlZ
=TjYS
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
