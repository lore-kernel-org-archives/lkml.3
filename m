Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaEYTm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbaEYTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:23 -0400
Date: Sun, 25 May 2014 20:43:51 +0200
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
Subject: Re: [PATCH 06/22] clk: sunxi: Support factor clocks with N
 multiplier factor starting from 1
Message-ID: <20140525184351.GM10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-7-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WuedheRyq6FDfQ9j"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-7-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WuedheRyq6FDfQ9j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:09PM +0800, Chen-Yu Tsai wrote:
> The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
> N multiplier factor that starts from 1, not 0.
>=20
> This patch adds an option to the clock driver's config data structures
> to define the difference.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WuedheRyq6FDfQ9j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgjnmAAoJEBx+YmzsjxAg5EAP/j8uuZJzA81AIufXGPuQUdXM
V7ocnrWndGKFVMuKSelUDumgOTeKylAIgoHeyCqRWFbZxf4/NDFP8t7BMZ2sWy+w
fNVsnehloauIgwJptrw5PpEM6Dj2y2xYccJQjDqi5LyGynPo/yxF+EvpHWq85/gJ
QtfXOMUADjUh4UdGcRYpgVqrUkS8HYYVHUpQMSq1QEnnGuRZk8118gckIFnnaHUa
RMwfEm2TyGqK2HbFVBfKWSdV+1i7+Vloku2wx/whA6S6W0XAhX9gsJDRUq4ngpMh
aTac53vhlm0Cii1RYBODgpgI96QPC84NJWxa16CrSRrGBYqFbTeLW1BUgQdkGIu4
eToXJYUx1VgaFnYIlK/818q9x6aImfUOx+Xe4TcvhrdvTmJ2dgSMzU/e1JFEuKPu
JkY91mXhgPlRJ3i6YG4TWgSa7RADkiUjmNHNYTFY0sPN4HWshmUByfh6F0WAXDcN
rEhiCXXTagx+EpNkIQ8DKZuz92BffVYLO7dLuxA/OPOer132iHVDEFX7NE/cNRUn
/beaFF9BP86UAHQMtCnq0WtYVkUEKfL1NNyCNHKq8OxMI4d3wo8nQPWQoK2aKHkN
E0NVZvU25lFu2EUfFTOIZ0fQZKWrR+VRIek595e2Ihl69VRWsoqOQgCr8u/rmlnK
KS0darkophFXROgXEVRs
=qVSG
-----END PGP SIGNATURE-----

--WuedheRyq6FDfQ9j--
