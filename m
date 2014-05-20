Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaETLQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:16:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaETLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:16:20 -0400
Date: Tue, 20 May 2014 12:16:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org,
        t.figa@samsung.com
Message-ID: <20140520111600.GL12304@sirena.org.uk>
References: <1400559942-5666-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P/co8ZP+C4wcN8Yg"
Content-Disposition: inline
In-Reply-To: <1400559942-5666-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Add 'mclk' handling for Snow sound-card
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P/co8ZP+C4wcN8Yg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 09:55:42AM +0530, Tushar Behera wrote:
> For audio to work on Snow board, we need the codec master clock 'mclk'
> to be properly configured.
>=20
> Currently XCLKOUT is configured as 'mclk' for codec chip and it is
> required to be clocked at 24MHz for the codec to work properly.
>=20
> Add appropriate clock handling within Snow sound-card driver to set
> 'mclk' to operate at 24MHz.

The clock here is connected to the CODEC on the board so it should be
connected to the CODEC in the device tree too.

--P/co8ZP+C4wcN8Yg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTezltAAoJELSic+t+oim9pTsP/j2J/0qbHTLC/QBWUCY5IppL
9OWrNQUz4XE3lAUVM0yRuVTt90+EdgM21A1qTq2ojz/MZXdST6udFkRBw6YRJKNL
xG0antQhhd1ez05mg78bkK2qzGb/oCGUQgJfPQoFhTlb471GnnfmR3K5TR98I08D
1IyA3SLq6JcRA0bBIWED1cGRw0T639QV3RGuTEbHUQ6ZDG5Nl8CwI8RdgPWxzkn2
xcTaMQa0cMDozcxz38cuqIWnO+jwv30fPPxn7CnzF+HE/qzKMj8PAdlc2WUQqNks
6YCbkM4N8EbodVQ5CUJ0/EmuZTA9lHazKsUF01eVFayM/QYcdZXoN7+Pqo/B+KSX
GMsYggkduK3A/vj5YbdtjDBGI+Hbt0wEQmuyPE3SCCbUKdrmGlvUNthlwmdMLpYP
QmKczhQuIJZSYy7QOf+jTi3v62CzqURBXr/p6qiNXwrVT7lGUdlUHug5i2igaCkO
VE3wQx5y5oIStUqOzdzi5Gr2PU6Vs7x4l/hMP0STRVlismD4AxSdDbXO8edF8BJ8
4Lr80mOIc7A5YSngWEbyyEydIcoRSKEmERmNF4R4/QW1Ja0emwgiHpLKRBQkrPE9
Vbq9mFUfJojXKFU2ZBb8rYKXznl737Nmm9XFsg2OcodtxShGo0TkSAi2jp9/97vF
fc9nkwdtSiXdRsD/cmOi
=z2EL
-----END PGP SIGNATURE-----

--P/co8ZP+C4wcN8Yg--
