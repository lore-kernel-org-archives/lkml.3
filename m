Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaJCBdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 21:33:35 -0400
Received: from sauhun.de ([89.238.76.85]:34853 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaJCBdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 21:33:33 -0400
Date: Fri, 3 Oct 2014 03:34:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, cpgs@samsung.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: exynos: add support for HSI2C module on Exynos7
Message-ID: <20141003013404.GI1323@katana>
References: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
 <1410859998-29285-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Content-Disposition: inline
In-Reply-To: <1410859998-29285-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2014 at 03:03:17PM +0530, Naveen Krishna Chatradhi wrote:
> The HSI2C module on Exynos7 differs in the transfer status
> bits. Transfer status bits were moved to INT_ENABLE and
> INT_STATUS registers
>=20
> This patch adds support for the HSI2C module on Exynos7.
> 1. Implementes a "hw" field in the variant struct to distinguish
>    the hardware.
> 2. Updates the dt-new compatible in dt-binding documenation
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>

Applied to for-next, thanks!


--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULf0MAAoJEBQN5MwUoCm2i3YQAIKvm5Upiuz0wPfoJEDKZeIp
28fXBYMV0DOCZ/Fqf/Rc3soar5knuAMVLNVnjAVuODim6gw34FC9yszFFjYZcmOv
UlSvsoLGanxyT3+LAyOcKn01LodzmcwPpxeL0Y1fzNPnaRb9N7Lw/6DK6O1sQHfo
NIpbo4xJzbGlLwdmuYoao7vVIu8oVerC724UqMQ6RSQBX0KzBRWbb6KX6ZtHgX7R
I2xRFUJ7etYL5x9yIwz2q1LGefXobY1pDpMpLQ+U/5CuyOITVHotQyF5ABZ8k4ro
fm/sgpL4V6hIymPxwjeZX2unFyTk9Acgr6+Qn9EDWWar9konzdGHvr5HlFaGkqzM
nFrHiNSSqnaCrbjpJxI6iSz6QcL6SOh8kiXu9Oun8VQwOt3+rGUVD+Bujlgc5jPc
gZ+hPcy9JhQbd8dDTviXZvBU09FVASE9NHXadj70s68RaikMWXTlvIIq2D12LhCd
7oKOnZJqIaoIea3Wmrhx3EBdAcqi2SzxCdySExitvsWHR2PTkwcq05itzl5XjUzX
YrQkMQlFKxAdajA2oJAa0VV9l63daVnNK9gPurIVqlBC1J8H9GYamxOgd5AUvpKD
Twrfy8gFWoJwIdF6qErReNENF60SK7mYkdcyAC3eUpWpubS5e+lH44KNVfUgwXG2
Dm2YmKuya+fQLWNdeKVM
=eX59
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
