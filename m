Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaCEEZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:25:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55911 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaCEEZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:25:00 -0500
Date: Wed, 5 Mar 2014 12:24:23 +0800
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20140305042423.GD13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpbaaqEfWJan1gxl"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 01/11] base: power: Add generic OF-based power domain
 look-up
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lpbaaqEfWJan1gxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 05:02:06PM +0100, Tomasz Figa wrote:
> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
>=20
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.

Reviwed-by: Mark Brown <broonie@linaro.org>

(mainly the binding)

--lpbaaqEfWJan1gxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqbuAAoJELSic+t+oim9qlEP/3Okw/4lgebLju+P/1YcDHei
U2AtkQef0Yof6nj2Y3u5H7cnjlC2pMGpZLNs+xP7TzHTX20ahTN8PHG47xXqmdnz
aiKSMY+ljj6VH+BlDieGiL8V/r7RkwRy48ZPfD1ua2+5iNzCt5cqCMjuOSWZQ0Zq
3Dx9Ow8DIJiwFT3sSQkDv92/jK1gqEYGeNab/vOOCwkIAXzoLjwvloDKcLXS8mku
CrBzwUW1SaFjQAjEKhiRhbA2CFNq9WrzVggsoESJYqDEonb6vuas2SYJ7t9io5Fw
Q8eEQ/MqGg6RHfWE626BS2KwQWPAhJHmsu6VuD3nxkVsYYpvzAnkf8lmkHJu2fh9
2HqLLqGRR5cPIPL6105f9LmzV+oUScCxvT+V9S/++JNyYZ4nkGkqlecV3LTHB/br
NWIDI/C6dfuwR1M5CDx1EeR3KcPEgw/tqwmyEIOY78+cTpRvOHazNlY9ZHROcx7q
LKHgwz8VtPRwhv3wzllFi2s2IzHXXTmNIAnCBb4meB1NDSd97HQlGJ9wP+r6A6cy
wzUSOPiUd2AL3nFnB0ppTiH3W4WcpUgL+biMsWQfSiJZaR/FGLj0ZDh9UMUfGqjT
16PDNGBj9HX5JC4jPj7ORhOb1P4vchMmg/qMblNS5XcAQYesTbg/NvovH6KYGutK
TSGYPet1l/gxwmEZkA0b
=EODB
-----END PGP SIGNATURE-----

--lpbaaqEfWJan1gxl--
