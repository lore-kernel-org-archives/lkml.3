Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaCEEew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:34:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaCEEet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:34:49 -0500
Date: Wed, 5 Mar 2014 12:30:25 +0800
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
Message-ID: <20140305043025.GJ13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-9-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hCH6UO/yhd9rsH1L"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-9-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 08/11] ARM: s3c64xx: dt: Enable SoC-level power
 management
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hCH6UO/yhd9rsH1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 05:02:13PM +0100, Tomasz Figa wrote:
> This patch adds call to s3c64xx_pm_init() from init_machine() callback
> of mach-s3c64xx-dt to enable SoC-level power management features, such
> as power domain management and sleep support.

Reviewed-by: Mark Brown <broonie@linaro.org>

--hCH6UO/yhd9rsH1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqhdAAoJELSic+t+oim9QbUQAIz0DbEe549m4MfgKbCh8eKe
B1kslsMqAUK2xpSJyJUFV9SGExpnXS04ga2QxDZOHxC5o1zMalJoQ/wYWzmCfNPy
sdP7wcZjjacs6jybd/Wd8helVS2iOy1EQmalFq8jGKWkdZ7YVjVRUmMTw9FjlU3m
z9OIdJ1hKC9hKqywXuTP4zAU85qJDn2UBPBG65UyceY8tY1+Q6I/sON7DXZQf37w
IqJ4bhtIdaHhLn/ywg6lqSEu0KgFFV8ONwrs6YnFhoIhQ4yW0I6YnrpHokhKEoRK
hJePtewBwKhUdj74NlRvp2GpniWqcxxCge7IwzNNxBWJo9yrPt2/kzW8trgway3G
7crjFDXGJjdMiGA3Z+uz8Qk8CL2XcNfk+zXQoa339Z/y2NGnHAoxU4KHVHdZFA9j
SDcj1m37lWFNJZv/oSv9oshrVNm9zTenwmD/nMJ0WNaQAwOiK2PVz/GH7/Df/deW
C3wSRTEwQUkv4ZFNkeYfi6n+ScaUsTStafAlXIkRs6EpPFOpZ/2S3VwrQh4TOHB+
NJMzJnoSdH9TXVS7/VFjJFVWJhZWfYmf3ZetfoIUpzygaj4HqkqSawXEeO5BdR7V
CzqXsst7UhuCZhxjglPV/KoRzwTUV2aIEJGzUrtIH1538gsd0Nhh7ELulR8i7eyx
Pqeljh9bvGgqKlWzezGK
=BI8F
-----END PGP SIGNATURE-----

--hCH6UO/yhd9rsH1L--
