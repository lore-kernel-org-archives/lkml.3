Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaLATe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:34:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45368 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaLATeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:34:24 -0500
Date: Mon, 1 Dec 2014 19:33:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: heiko@sntech.de, johan@kernel.org, lee.jones@linaro.org,
        grant.likely@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Message-ID: <20141201193357.GO7712@sirena.org.uk>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vZOSZtHto+Zdlc0"
Content-Disposition: inline
In-Reply-To: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 0/2] poweroff-source DT property renaming
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0vZOSZtHto+Zdlc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 12:28:24PM +0000, Romain Perier wrote:
> The goal of this serie is to rename the property "poweroff-source" to
> "system-power-controller". After discussions, it makes more sense to rename back
> to the old established property name. This patches serie reverts
> commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").

> Changes since v4:
>   - Renamed the helper function to of_device_is_system_power_controller

Applied both, thanks.

--0vZOSZtHto+Zdlc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfMKkAAoJECTWi3JdVIfQSJIH+wSNcmiYnzlZRt4VuDHTomaW
0VXUzfmD25BkY3HfzYObobws7UTVDdIVJuhhHxrt1v54n7gR9IvvzNmE5OZLs+yl
1tmLMGfx4Dv/I40967XtBUpPNNSV/sA2yyV90GqoKA3sd2S0ulJR3y6CKV+vJi6p
iuVttSQNiJeiOpuDbYoSSqoCGP9YiWortLGdf5YgVLK+g/P5Ryqg0StkBipao6w5
FhJkOUdSzuVNrBeGUpfPeIIaGGQZ6zIyS8WPqZyk+1STRMKVG15+vq9Rztz2Ew81
Xc3HVdhyw2L+H9041W7gNRJydIoHbg6p05HiF0Rsgg+IcEkbmJYW6PrhWuoflvc=
=daGv
-----END PGP SIGNATURE-----

--0vZOSZtHto+Zdlc0--
