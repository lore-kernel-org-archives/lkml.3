Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaKGPzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:55:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49487 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKGPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:55:53 -0500
Date: Fri, 7 Nov 2014 15:54:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107155400.GU8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XzDp6KY4NBYgEz60"
Content-Disposition: inline
In-Reply-To: <1415365205-27630-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 2/5] regulator: Add function to map modes to struct
 regulator_desc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XzDp6KY4NBYgEz60
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 02:00:02PM +0100, Javier Martinez Canillas wrote:

> + * @map_modes: Callback invoked to translate from hardware to standard modes.
> + *             The function returns the standard REGULATOR_MODE that maps to
> + *             the hardware specific mode passed as an argument.

of_map_mode - it's only one mode and this is mapping to/from DT.

> + *             If the callback is not defined, the "regulator-initial-mode"
> + *             and suspend states "regulator-mode" properties won't be parsed.

Just remove this, it's pretty obvious at best and going to bit rot at
worst.

--XzDp6KY4NBYgEz60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXOsXAAoJECTWi3JdVIfQiSgH/j18Lc0MhLd2Aqc2JZgxUV2M
/dBt3zXiUGo46nRN1FozITuUSKxCmbzMI/Cwp+fyY2IrGuJ9hbOn1Si0iSeop548
8DxkPx0Kp2sFR5yujEQK38Nq5irq72eLzEkE9GUAXIMcQi2vV+QySr0kxn4+pj7z
illyWKK1JWfy878SV/GYaBA9Oc26jREN4jSaWYNxcF11JXTSZ2P8yOKcvYXpO1c8
qCgK5okIpY+IYxl+3ZYbQROvX7QbhkD/Sqf0G/aUutArUJVDl78o66KrIi66vCTw
5/QS2ggcb7YUmb6MWKAYkEDVZfLVEsIwHgGayRwDMXxcz2QOLI2PJscJv53GVb0=
=5Yn1
-----END PGP SIGNATURE-----

--XzDp6KY4NBYgEz60--
