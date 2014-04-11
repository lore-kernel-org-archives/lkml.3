Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaDKNKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:10:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46036 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754247AbaDKNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:10:09 -0400
Date: Fri, 11 Apr 2014 15:06:17 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 2/7] pinctrl: sunxi: disable clk when failing to probe
 pin controller
Message-ID: <20140411130617.GY28585@lukather>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397137966-30818-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j13PAD5Nz8dz2ik7"
Content-Disposition: inline
In-Reply-To: <1397137966-30818-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j13PAD5Nz8dz2ik7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 03:52:41PM +0200, Boris BREZILLON wrote:
> Disable the clk when failing to probe the pin controller device.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--j13PAD5Nz8dz2ik7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTR+jJAAoJEBx+YmzsjxAgSB4P/3vvTbh4EWCCgZ163QeAgBMR
ZuJDR93bs0B7kMCRkVAZnT6V7Y6UKFlozTkS7bHmIE+vYAcT/P+lDeGFzIWFAYd6
/YDNB11PS0SDsUbmCPGBKQ8EqOn2D7Ud+hu6LEB3v88Ud+xXxnrr2ge5Jj1gtk9v
orCSXWL6gsihpslFosWki6BFE7so3/358oB+pX9Fn4u30JHvU6CA/wUPubmElT7x
vgYigU+tZEAtqpNxNDnDWti0cOhv4zOil7T2r0DBMqdbnqiahD5WHDf6pywtfYqs
IryroWUwlUJ0myPb0p5SrSNq1OyCT6ffNw8SaQ8ZWNOE7tlnXwzCXztFkRzUUev9
SsjDSXrhL2L7WLM5Bo78O23TfC8P2l82SFpHoeCPw486WGAwS7abEN8dsvqgDIL/
miQueZOJoGbAKJ1yo+4dYRNGDZfix688Qiio/H3AJKV2WgW0Zwfo9LSYMcvCxsr2
3lZVmZaa9DeUmjUX+Qe536DzASGN9/yTadM2qZuMTTyJG2vZKUX8gfSXExI0l0CL
agx6vcArQ3ItSRs1Gaj6p7cv1tK2RsjqnRC1bXcQt0/vPy0+XSdKwQe3hKXjOtO2
AIYiNIexTfSPsykRD1sd1Xven3hnL6OTjGoEaOPBSyxkw5hVApIMI0pMd/zPMtfi
3v/dID7iAhGugxHelUKU
=zkvY
-----END PGP SIGNATURE-----

--j13PAD5Nz8dz2ik7--
