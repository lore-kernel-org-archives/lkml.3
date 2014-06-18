Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966436AbaFRMaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:30:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52946 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966285AbaFRMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:30:04 -0400
Date: Wed, 18 Jun 2014 14:29:03 +0200
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
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 18/20] ARM: sunxi: Add earlyprintk support using
 R_UART (sun6i/sun8i)
Message-ID: <20140618122903.GT19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-19-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q43QQdzFtqSKgsg+"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-19-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q43QQdzFtqSKgsg+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:55PM +0800, Chen-Yu Tsai wrote:
> sun6i/sun8i have a UART in the RTC block group, which can be used
> as an early console. This is most useful on sun8i as UART0 is muxed
> with MMC0, which is not available if we boot from MMC.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Q43QQdzFtqSKgsg+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToYYPAAoJEBx+YmzsjxAgIQsP/2tedrS0v6LTLdvfngQkTDfg
/qlHdMkkyMY7cZwAamr1k/isVJ2GUrTAE8ERyY7Hq1wjc/DwTXVQIf9fI2xfSzjN
ePYhCwTPxDeEv0QZIjJHiWvIkteT9tsBCFm6X9Jp0v7tz3ZPx0EdslCCaaRhnTKL
jFSOS0nhUXBxn8RrOQ0fHkMlrAhjAqCiPzeksqEdwGOH8LeNQVduxm/j/dlF8mmu
9gUvF09ExtB+4g3fly/s4Tf5ki+R47uP6YTT3rjbkjQ4AXCa5l5vMlcjJSE2hPTt
vsK4Tq6O668xg9HbOqQaS5270wEgYIJdOJYaQCBMAa5a1C5om9nEFXwx52pr/KJ2
5fsfRu6jc4LuHk5A5m3DuDVmBImXPAMedPvLxTN3fDBWqQNrZf6VOHjt4D4FVMh7
nHNhis2UlFWwuarvODw5eOXPytlgsXJPP2DqFLyxgoWSVY463umLIjirRchx6ZGF
/YmC+pPf2tCiOjfLkdI281iagHg/l0v+sufVq1CSep5fZn7aPJYAv7BS+UZacLt5
I96H4yELqVA8+Apger5m7LHyTUuCHS0ybFEI5zEyRryyy5qoUjgIJZZ4WV+6odef
lfLFoUtXBTNyKkCkFr+WCKJLj/P2O8kLXbLvkZW632lokRIPkBMGCOgQ8825lnUa
ptj8vs559PfAekHd59k0
=Asgi
-----END PGP SIGNATURE-----

--Q43QQdzFtqSKgsg+--
