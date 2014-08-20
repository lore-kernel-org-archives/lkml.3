Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaHTSOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:14:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36254 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHTSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:14:17 -0400
Date: Wed, 20 Aug 2014 13:14:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <jg1.han@samsung.com>,
        <s.nawrocki@samsung.com>, <k.debski@samsung.com>
Subject: Re: [PATCH 0/7] usb-phy: samsung: Cleanup the unused drivers
Message-ID: <20140820181406.GA6023@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 14, 2014 at 07:53:53PM +0530, Vivek Gautam wrote:
> - This series is based on 'usb-next' branch.
>=20
> Now that we have support for USB PHY controllers for Exynos SoC series,
> we are free to remove the older usb-phy support.
> In the process, we are removing the entire phy-samsung-usb3 driver, and
> besides that all support for Exynos4x and Exynos5 from phy-samsung-usb2
> driver.
>=20
> We have also removed the older USB-PHY support from ehci-exynos and ohci-=
exynos
> since those drivers now can use newer GENERIC-PHYs, and don't need the ol=
der
> USB-PHYs and related code anymore. These patches for ohci-exynos and ehci=
-exynos
> now replaces the older sent patch for phy sequence cleanup for them.[1]
>=20
> I have build-tested this series for exynos_defconfig and s3c64xx_defconfi=
g,
> and have tested the EHCI and OHCI operations on smdk5250 board, but
> have not tested the actual working due to unavailability of S3C64XX
> board. So can someone please help me testing this series.
>=20
> [1] https://lkml.org/lkml/2014/8/5/142
>=20
> Vivek Gautam (7):
>   usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver
>   usb-phy: samsung-usb2: Remove support for Exynos5250
>   usb-phy: samsung-usb2: Remove support for Exynos4X12
>   usb-phy: samsung-usb2: Remove support for Exynos4210
>   usb-phy: samsung-usb2: Clean up to leave only S3C64XX support
>   usb: host: ehci-exynos: Remove unnecessary usb-phy support
>   usb: host: ohci-exynos: Remove unnecessary usb-phy support

some of these patches are still RFC, can you resend without RFC and all
proper Acks in place ? Also rebased on top of v3.17-rc1.

thanks

--=20
balbi

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OVtAAoJEIaOsuA1yqRElecQAIHwWll+bKsGql97Nhu1EMRH
xCbS2nHGZ1BlM5iC7OQ1XtoCM4slQY6PRxd2AEJuQN2aODXrS8w9nGAre+p91BOX
dLyIOarMhqp8Rh6K1V35T/V4ZiRZ2cONDqQWoA5C0LhwUoD4dWToDfFCTf5gqBEh
bZfJYqZqHLoTfVkMf1TwK12p1tnNef01C9QfuUZnK1B9Cvb9igblL1+aAhaH4hT+
AlDtn7aEt5MsqQf8JaCLS/jNdgmA4SdlYMjyja0AzNn4AWe/pe03EG9IBHGAw5sr
4CokNDDGy55aKY021Q5ukXfXm144Pt2pb/VHGFhxJL+CBDgMPd4qWUJzjVqcDiBn
FrpJQXLLzd41dQaFYjWMPukFdATQkFNarBzfJ1wV6NPLLi073JyW4aTrnD59OVMv
YAl12WvzuGpxfavY9fBLKX/Kp5hKH934LyQNldEqFHAtu3s1k84oc4TougwuKFWM
Exai2UsEgdvhdSBFgrZ2v8iZx5Ld0C1azf1MTX2oaEPhvDe3NikqYkTx/Afctw95
0d+mtlEaHn6qdZft+NcVUgjxAyE9Ll349aRnz4smgjtZKZomaeLWJvHBcT6gLjae
els8E+V/c0TOKihuaqUJYzqtLo8BXBc1Zo8N4I6PCTn02ackQnrCgLFHmHwwp9UG
/iQsiUWsaKe3DLLdD/+t
=9AJT
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
