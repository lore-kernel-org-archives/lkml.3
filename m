Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbaFYQpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:45:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37598 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756246AbaFYQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:45:10 -0400
Date: Wed, 25 Jun 2014 18:41:07 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] Re: [PATCH v2 12/20] clk: sunxi: Add A23 APB0
 support to sun6i-a31-apb0-clk
Message-ID: <20140625164107.GA19569@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-13-git-send-email-wens@csie.org>
 <20140618102623.GQ19730@lukather>
 <CAGb2v64D6qBtXGXzn25443s_oj_=Z-u_P6+-MX52Lz54+9bQyQ@mail.gmail.com>
 <20140619092847.GW19730@lukather>
 <CAGb2v64hFc7oVdydoNzKVqjnyNUxuqMXX2AiV3aJLFizKvkOPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <CAGb2v64hFc7oVdydoNzKVqjnyNUxuqMXX2AiV3aJLFizKvkOPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 02:13:58PM +0800, Chen-Yu Tsai wrote:
> > If these two clocks are these different though, maybe it would just be
> > easier to add a new driver. These are trivial enough anyway.
>=20
> Yes it is. But it adds more of the same boilerplate code than actual
> differences of the hardware.
>=20
> I'm inclined to keep it as it is for now, unless someone strongly
> objects.

I'm not strongly objecting, but I'd strongly prefer to go with two
drivers.

I don't really want to end up in the same case than with clk-sunxi.c,
which handles a lot of weird corner case for one particular clock,
while most of them are just a single-bit gate.

Especially when they have nothing in common, which is pretty much the
case here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqvujAAoJEBx+YmzsjxAgIdEP/2M8UjpshuzvSXZrCUTplpYy
lwDLn1Nnmo/ycspMBwqi/rCcD/0e3QjAuy/EwlpR9Y4RPPRy2Rt5mNQZ7uLq3Cj3
C4UPo5Qjf4b4x9lYU5LR6FcKn9QWE/wQhI6Kta0AqWfuh948RVER9kIQZYDyFqq4
MFUaG3lpZcxIWc6alq0B3oxaKfwHUFZVd/f+8m8Xb/VKxlMh5ATtMmKjjMXKcGkO
liNacaPJCagQlj77V0zvsFwlOlXIa7jKg1NS4UiUCxItjbcRnjfcim/aS8wqs9Qz
4wmwIwPSPlaT/HRisz2pVUncwXDycEHLoAmJPbsCZfv+aHU7pRFInHhZ0uBbWzyJ
etzNQjw/9XSxzjGOG/ZdMHPRNReYkibiqzRK2UTdTAB103hHqR1FH/WPpZCAUu44
wDoo5epV0RTUiQxRRf4QMivDjQJXingrfylQjp5trNjS/B9E6RsT9p0POmP53RgO
wojJFE8K9B55ws23QEGVpQj5e2sfTcOgJjY679UCk7UBC0xPtfStVEbsvGZJpBVy
8NGPMmkP32vPgajAQwDf+jeU1Gora+M4J/4K2/f5wHUR9DmWHEvzdJpVxbijOHel
K0EasHgc84P2PRVnIqDgMavq8hqexzD0hJtIxEBah6nh4BJQjZX2o3K/BiF8JUxK
IZpi4gkMaHKLY8GH4TEc
=Peqk
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
