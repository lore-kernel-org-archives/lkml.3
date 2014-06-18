Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709AbaFRKKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:10:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52203 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965085AbaFRKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:10:17 -0400
Date: Wed, 18 Jun 2014 12:06:21 +0200
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
Subject: Re: [PATCH v2 10/20] clk: sunxi: Add support for table-based divider
 clocks
Message-ID: <20140618100621.GN19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-11-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QQNwO3VdVfodZayb"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-11-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QQNwO3VdVfodZayb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:47PM +0800, Chen-Yu Tsai wrote:
> A few of the clock modules have odd dividers, such as
> the 2 lowest dividers being the same (2), or have the
> same divider when the highest bit is set.
>=20
> This patch adds support for optional divider tables,
> so the clock framework will know about the odd values.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--QQNwO3VdVfodZayb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToWSdAAoJEBx+YmzsjxAgPcIP/39SdTi3g5pFiGnZ8Q4zhyrv
6yTHjDumObD1eH/UkOOm8R9gM0w1Mbzkt9W644+65Q8mJR/ugxYWn5JhLqBaeddu
O+CqPeP2jhxZP0vY3WTnHTXh2pye1sdXIP2U/bdEyvFg2jPrZFpR6MtXz7Kn9hah
HH6CPhzEA0t153jAc4AINY5IXIjFnh5IzBevEh2DbZ1wKlBxMbF3EOeW/TRCQPug
6GxrKh6Pd3YD1+IDNe8B2BflXdiUs6j05ZlzAYF8RHqa9DBrTuvH9MJexY+NXmk/
DVOfVVq9XRbMyohXCzB6ZSbFNDoTf7UP3U7GKQy2rhq1SdpBmzBV23EUMn+Xy+R9
B7WJWslKGT5kQ3ZSIDf8bGIYdAHk9/qgKEYRrjOUx304/yofRGm7yLJLO8QUVRg5
41OpuUccbH8BK5EL/ys1Gzfc1h/0b4gVZeFavqdI/bfEleUHCmg15AlFq8XFDAjf
hUb3Jbt23GzUC43obzM4r3hB403qxgXOqgxnPVg3qlX4UJeBnnRKOun/WJUrys2w
d2mHsyWf7jPFZ6x+QojiXvLimdK2W4hJfg4DbBugHiGl3ePvd1UNgHKpD55t1Jio
noBtu48+tq6fZUK1nwvOGLsB4q4wRgjAtmQOgrTCGAei9/glEXtG524/iSe5eawC
uSroEbQDsYFCLd0CVs20
=MADy
-----END PGP SIGNATURE-----

--QQNwO3VdVfodZayb--
