Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbaFRJPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:15:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51733 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933182AbaFRJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:15:50 -0400
Date: Wed, 18 Jun 2014 11:10:06 +0200
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
Subject: Re: [PATCH v2 03/20] clk: sunxi: move "ahb_sdram" to protected clock
 list
Message-ID: <20140618091006.GI19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yzvKDKJiLNESc64M"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yzvKDKJiLNESc64M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:40PM +0800, Chen-Yu Tsai wrote:
> With sunxi_gates clocks registered with clkdev, we can use the
> protected clocks list to enable the "ahb_sdram" clock, instead
> of looking for it and adding CLK_IGNORE_UNUSED inline in the
> clock setup code.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--yzvKDKJiLNESc64M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToVduAAoJEBx+YmzsjxAgtaMP/jYzR7hHj+anXBPwRlYhm2iZ
ld/VmhxkOZnOKfeElrXRyZeV9Ks3PiplhHxhOyAFZG7Ep95jlgfvXoT7P4cUgp6F
vwtxDsFdjLUtuwRw9uutphn51IzKOc9tiqBUC8wwcLnvkLw7y5aJkRkPB++LEf0h
5PSwCybbCjFcCKJ6W0u0P5d/ECMRbioOMxRqbwz4tmL01EGq5Gw8xtAjY5cQzN7T
twJGtsPIsxh9okTAw6VRq3OhNRp8C0t53lWBRlgPoiXJMIy4OEdWuVZBD405g3Vh
hHky5SW2wKDBFstDB/XWueb24rDH30LYWGseeOL+CImPktfBEyHSfqLrKYzreEfT
/MDOkke5uJ4aSAb1HdQNe/F2V4VfqKamhkqoEF4E8+c7WQxXvwA7fRgjQwgCUyO3
B/9sa6NNVZlMq3Ceom8G5nokb5vWOAaPnmWkmcLIgTIhRVE9taxeLtBuazIqegZ+
/Xi1sDh6STgBn8KE5Cm/W97WS3tvqVyDDFTlYmozTFBsjR7xFO1Z8Ny/XZYxcX/K
LJFyJVFzvL4J6x4vnSIh59Glp8IDZLaR9+D1sOgvWVs/FYMUXeT3EC0o4SlST7FA
alOOaGq1W2UlwYv9fok28vVCN+t4mwHMmoNG4PtinM+Ph0Z3Y1hpjtxHvRdZCXYG
VNcKO+52NA/6J7a1231i
=2KR7
-----END PGP SIGNATURE-----

--yzvKDKJiLNESc64M--
