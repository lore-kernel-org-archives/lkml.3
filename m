Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3HLIR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:17:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52435 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055Ab3HLIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:17:28 -0400
Date: Mon, 12 Aug 2013 10:17:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCHv3 02/10] clk: sunxi: fix initialization of basic clocks
Message-ID: <20130812081726.GK2911@lukather>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375609657-15434-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ukW6Wv09KNCUAh1u"
Content-Disposition: inline
In-Reply-To: <1375609657-15434-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ukW6Wv09KNCUAh1u
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Sun, Aug 04, 2013 at 11:47:29AM +0200, Maxime Ripard wrote:
> From: Emilio L=F3pez <emilio@elopez.com.ar>
>=20
> With the recent move towards CLK_OF_DECLARE(...), the driver stopped
> initializing osc32k, which is compatible "fixed-clock". This is because
> we never called of_clk_init(NULL). Fix this by moving the only other
> simple clock (osc24M) to use CLK_OF_DECLARE(...) and call of_clk_init(NUL=
L)
> to initialize both of them.

I'd like this patch to go in 3.12, and I need it to merge quite a few
other patches. Could you either review or merge it?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ukW6Wv09KNCUAh1u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJoVAAoJEBx+YmzsjxAgG88P+wQhLOtEbZuKoESW+tI0s2jA
OTKPGGwo6g7lLBYfaFSwhV1pmRNSpNCRT3mmbFRqLF/1O0aTaJXFntoxDCxGN5tR
ts9OfOO9FbyJgwQNIyD2JYTvA8NxQ2CkPrLqMkhrB/+7KND31XWXodmuoIXLA7F9
xiD62WjIOHzGr8l9cr2fFBX6pVbLON48U8fOfNgjMaKtiT0IkqAYHTNLA+KaC5Cq
+gwhF6z6fBzhOtUatOlMAVyY4dyVyyEC6sbqwf3VPl/MLaWUBLl1g1yHPrXWCpJ9
njlW2b097EbQykEK+mfBMClpQKbgbJqrcFXblnXN8xFqSlWF+lM5vvX6grV+DqX/
TmVCpjd9ATHUetEmrgoGZAMV4WKAseabaPou6qkUIh6cvhhr2sJRmR0giZFBM0U5
/JyZl5UFBD+Vre3ha+zCwbPuTIsQNA50LyCRov9YLUD0GhAaG8GQdDsR5/IMUQZh
5y6wzSVHtDLbVGpyegwkdT2SApkta+SNPoas0TmKEjEfr+/3T8n98eRBil/m8xFj
8qnGsBtKciAlDsh9paLYUj8oyGJE7++V9k6pUJaBxO8ttlQUVzTdVfaQSQsghNo6
mApfbsZ4RU7O/WvAmAnvTXStAtG+qdZyIZteQ0W3Sgwe3QXLP0Ycx77sQ5hRO9c2
NHGRLSePDaGBoQxtuQi0
=F8UN
-----END PGP SIGNATURE-----

--ukW6Wv09KNCUAh1u--
