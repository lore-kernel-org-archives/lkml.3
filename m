Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaJCBdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 21:33:55 -0400
Received: from sauhun.de ([89.238.76.85]:34860 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaJCBds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 21:33:48 -0400
Date: Fri, 3 Oct 2014 03:34:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, naveenkrishna.ch@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, cpgs@samsung.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: exynos5: Add Kconfig dependencies
Message-ID: <20141003013423.GJ1323@katana>
References: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
 <1410859998-29285-3-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Content-Disposition: inline
In-Reply-To: <1410859998-29285-3-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2014 at 03:03:18PM +0530, Naveen Krishna Chatradhi wrote:
> The i2c-exynos5.c driver can be reused for the HSI2C controller
> on Exynos7 SoCs from Samsung.
>=20
> This patch adds the Kconfig dependency to choose i2c-exynos5.c
> for CONFIG_ARCH_EXYNOS7.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Folded this one into the previous one.


--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULf0fAAoJEBQN5MwUoCm2vCkQAJYQnwhuPCb56462MVMeeLSt
ropoHhpNP2JKM57YTW1SgKlxv50zzdz0e1rbgPdmsijgNEctyzrbH8QWOrljZeo5
ue56jDIgrzelyH8B7UUiZwfpeohqNA5CgQ03mYRefbZOtmMqNBlhao6Wfx200kq1
xDFIvMWohrsiklELK0pnrog6ZYB+EAJXk6gDFCME0xRs4GM9Alxmqadq+1ZtsnV/
ellOydCXmR8etCx+7OulGAsl2p+eiVvlLvGgRcTMbHP/pPtAVcKCIRRfF5H2c+S6
XyaoNTK42ZXjpqug9yFLjbESHlmBCoikWTM4Ns6jzkf9/Hqv2QsH7c8GNUnIbLm8
GeGl26lrH41Yhti0mEwlBEwCRQxY6PVfnepXSj5nV7R/FiNFLUuLUkLdc+yxZrAt
LY167/abqCt43A+vcO6fwg5bYZmXn7h+RvExZonN8gLtFguvQT8ZruHiZNdjJpGB
yvVLs4oNhjLZwYrRHVXd3Ql5AWCVhqc+J3J8ZqdqEah6dj493kLWRsX9XSGogl30
zDCInU4xKqNTEl2kjIgzccW4LsKjRnWN1MIvNLBYvjhC6gybDU3M5GeBIBBditi3
SVzZZi9RCmzwKu7tM50mQs0chmv7idXqEUACyJC+r3asCjCIUeFlWaK3vdxqVkSU
wA+r4uEv67Gox3myjm26
=Qf16
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
