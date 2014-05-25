Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaEYTmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33547 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbaEYTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:47 -0400
Date: Sun, 25 May 2014 20:59:40 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 11/22] ARM: sun6i: DT: Add PLL6 multiple outputs
Message-ID: <20140525185940.GS10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-12-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WVXkb2QE2eH0aWe4"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-12-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WVXkb2QE2eH0aWe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:14PM +0800, Chen-Yu Tsai wrote:
> PLL6 on sun6i has multiple outputs, just like the other sunxi platforms.

Which outputs?

If it's the PLLx2, PLLx4 and PLLx8, like I said, use fixed factor
clocks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WVXkb2QE2eH0aWe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgj2cAAoJEBx+YmzsjxAgEowP/iCW946tod/iOD/bSskVfFVr
b/p8jh4aOV7va351fFlOaIVYotPywPK3ReP2QLtY6be4e2MdgqGHijkUl+fNjVcf
fQlH/Wc9QHX5vUjrCbnLxJwyT+TfX9SJcOoIntG7rIn9ai6ToUtxH6cSdkS8QXrS
IhwSaCrTAjSfcAYoBeKGOFlt1sv7LmNUaj38prxgbqhAq15k1oC3rGlw5KnVBQOL
ALAp21UHBSL6UkUqduTGwtwTBg9zyY50tGrv5ymaT7ZbevGU86SCdL1sESWbwP8Z
6+5Azy1PZ+DViE6gyYgjIDP1HjfvGehvpVO0W+OKe2+JnY/vyEy/W5gbiSKUSsgp
7Vyskl7dRuqQCh8wK/l2GXGAIMB5RvHfzZDBn5A+W0cqG0rNoWiibNzdBB4ILbdz
3YUrt4Vj7HAJB6Ar0V58DDqbv4s64hjE1gJpgF8KFbTIGJ2P1ePvJgfAuMWv8oCx
4PflwNCZfvWyOnLslnl6pRM8bg/hvkJ38XirJ96xYy3nKuC4jK667rDwf0IXzOFp
RHE1mAEO5dRypM7mheXcz8slucvMrcMev2hGbl8X78JoYXN/oSCXREy6dGhjlX84
koUneNgnkVDRHcvDSlFd7Rcr736U5GGAT4uDLfoxFQvwGXkNzSWrKzaDY4DrECQb
6BM+y3AdLwPkFGtWSyb7
=E0uU
-----END PGP SIGNATURE-----

--WVXkb2QE2eH0aWe4--
