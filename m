Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbaGPRfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:35:53 -0400
Received: from sauhun.de ([89.238.76.85]:58248 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaGPRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:35:50 -0400
Date: Wed, 16 Jul 2014 19:35:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, javier.martinez@collabora.co.uk,
        Vincent Palatin <vpalatin@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: s3c2410: resume the I2C controller earlier
Message-ID: <20140716173528.GF2759@katana>
References: <1403654214-25072-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jkO+KyKz7TfD21mV"
Content-Disposition: inline
In-Reply-To: <1403654214-25072-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jkO+KyKz7TfD21mV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 04:56:54PM -0700, Doug Anderson wrote:
> From: Vincent Palatin <vpalatin@chromium.org>
>=20
> When the wake-up is triggered by the PMIC RTC, the RTC driver is trying
> to read the PMIC interrupt status over I2C and fails because the I2C
> controller is not resumed yet.
> Let's resume the I2C controller earlier in the _noirq phase
> (as other hardwares are doing), so we can properly get the wake-up
> condition.
>=20
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Applied to for-current (because Tomasz said it fixes issues), thanks! If
you think the exynos patch of the same style should also be in current,
please let me know...


--jkO+KyKz7TfD21mV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxrfgAAoJEBQN5MwUoCm2csAP/R2yIXJfGbOybLhBnLZ2ntPT
BeMeENUOjBXYKYzbDbbHiotkTsOV6d51o5+pJjDynREhxTgwJhSgO03QhReEVdGr
1Y/PdqNgEYXhcKD5ypaIXL1zLHohMSune9RlIksn5WINRo8kwkHKRx1gYUhsYofl
YFhmRad/yBsmiTOq9tNN9ML1nGJ6eWLevkGQHy5ZS3NaZiiYGC88fHR743By+vYw
sGOOX/CHVGe62aNi3UVqqO5IZIQOh2/PHCOMdmrrDtpqSqu4JMTLHRxi/ADj98Bo
7gdOSsIyKBYsb5vSszWna2/mFaNNMb11FlC40WerPAB5VGeYRq/YIC4QtJTtUJrQ
43X1v1F4W0UACry6NdAxBGwHtTTFXKRotqTQ6xkHKp0ICfpCf4/nO9NZ7/rYg24W
I2vjTuLJjZ0sBM/R4bB891KAiEFxVkbk5hwl7I+nN9WSpImwAoBgz+8kLxbR2rpe
6tKlqXstX2E7yTkeZaYQrkHEXmoU7IsYJxj0XNXwKjIENCQcrQatgwwtdjjwRxrT
pBgg2D08mO/f+fxH94wbPhlXLvc9PWjcxPkSlmwnV+R2MCrJvWopdOS6+VU231UD
vlUiJvljbQ0r4bdC64LqvJzLK9y9Y9mSmUe2q8Jnu2r8Ik1o3HnidkrrwCWPjBnq
ldeEZJHD++3fMgd5LIAL
=mZ1d
-----END PGP SIGNATURE-----

--jkO+KyKz7TfD21mV--
