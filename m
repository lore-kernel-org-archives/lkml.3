Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbaFRJkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:40:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51918 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965210AbaFRJkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:40:15 -0400
Date: Wed, 18 Jun 2014 11:38:50 +0200
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
Subject: Re: [PATCH v2 04/20] clk: sunxi: Fix gate indexing for
 sun6i-a31-apb0-gates
Message-ID: <20140618093850.GJ19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKy6e3LXpfmanBFM"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKy6e3LXpfmanBFM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:41PM +0800, Chen-Yu Tsai wrote:
> sun6i-a31-apb0-gates supports using clock-indices for holes between
> individual gates. However, the driver passes the number of gates
> registered in clk_data->clk_num, which of_clk_src_onecell_get uses
> to recognize the range of valid indices a consumer can use.
>=20
> This patch makes the driver pass the maximum gate index + 1, so
> of_clk_src_onecell_get does not complain about indices greater
> than gates registered.
>=20
> This was tested on the A23 SoC, which has a similar APB0 clock,
> but has holes for gates to removed IP blocks.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tKy6e3LXpfmanBFM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToV4qAAoJEBx+YmzsjxAgLb4P+wRQ/AAQw6rsywCFTZY8xj5Z
e9shBl7/VbZXetPPo40yuk9QS4H2Fy6iYyx9SBYM22ToQvtyXtIQXpoRgOQnY/2i
l2rf8C7II7qlSZklSQsYTEr+0WtPjQPp7i7t0i2mqp3xWII8wP66pLmKJ8RH3XU4
5hmkZZJ+1ViR1MPHbtA3RY6GlIZ43+tYFJiEvzyKVJ0WzpIEcSShyb6DWUxM8Y/6
GEIlFslFJds9oDRqy/paFsgW5EyfiPm4O4kgA/C2JV4KHB5Zs8hOnREE+3Bjw67m
exirHbAjUVaLda9bv/6JS6s8DrmjAlJYdAY/LnzUkea+sR2O61O8sN7+BNjaDXKN
zo65CDf3G/tdjF0c2sZ0SH0SO6MS+1LXmOB7fOQttEOnFzipVZtHYb5y84TLEi5k
SWaip6Csy2eRiTD/P6GAXDsLoQLVzelCXLJuOtowshD72uMuA6qGC8B8L+zv+CjQ
zX5T1SsNfXPEHCLyRoeUTsUYZPueR26BKstTVvfiaCqfETCCsHygNpTI4qI/wP+b
RxT7CT93QlU/S98lln/M23o6CTWbXMTu6ui2E1gehxBH+BxznZGd8Y8Ftc5a23Be
3f7soY8nmuaR3hcPE/onOq8iq/geJ5wuR5ffksemQRGNdIBWMDCMHormXLm5l+DP
rVKmBl8rdbYL8t6GkVYM
=SWQl
-----END PGP SIGNATURE-----

--tKy6e3LXpfmanBFM--
