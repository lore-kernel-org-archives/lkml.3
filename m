Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaIBOhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:37:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaIBOho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:37:44 -0400
Date: Tue, 2 Sep 2014 09:37:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Daniele Forsi <dforsi@gmail.com>, USB list <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, kishon <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for
 Exynos7
Message-ID: <20140902143711.GD16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
 <CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
 <CAFp+6iHsfg6Ru0LBN=JviV=-mSdmuSo9Te3EXYF+X8jssD_BYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHsfg6Ru0LBN=JviV=-mSdmuSo9Te3EXYF+X8jssD_BYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 01, 2014 at 01:30:21PM +0530, Vivek Gautam wrote:
> On Thu, Aug 28, 2014 at 8:36 PM, Daniele Forsi <dforsi@gmail.com> wrote:
> > 2014-08-28 10:02 GMT+02:00 Vivek Gautam:
> >
> >> This USB 3.0 PHY controller is also present on Exynos7
> >> platform, so adding the dependency on ARCH_EXYNOS7 for this driver.
> >
> >> +++ b/drivers/phy/Kconfig
> >> @@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
> >>
> >>  config PHY_EXYNOS5_USBDRD
> >>         tristate "Exynos5 SoC series USB DRD PHY driver"
> >> -       depends on ARCH_EXYNOS5 && OF
> >> +       depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF
> >
> > shouldn't that prompt and its help text be updated to mention also Exyn=
os7?
>=20
> Right, even that has to be updated accordingly. Will update the same in n=
ext
> version of the patch. Thanks for pointing this.

I would rather change that to ARCH_EXYNOS, unless Kishon doesn't like
that idea. The thing is that this will likely need to be patches for
exynos8, 9, 10, 11...

cheers

--=20
balbi

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBdYXAAoJEIaOsuA1yqREy/kP+gL2LlhK87Z2C3Yj98QNTCm7
5eWyPXvWu4qFCUb/bS/XyZKZ1fILcTUEN6U/OJsreTwLZv5Bz1CR/vUYRMyenBj2
UKqoqHgzUZXCVC8XpUwm5G7LcNnoZfT5f7KarxT7FrXKQ7Yc8SLZm2xXkxySk8Gq
4ts1cfj1NdGIGX8S9vv5+OH3+Go05SILNxsmSkedvH4lfHW4F5LRQnKkgLWmOaoK
2P3+t7jjepTw5tRbR2KYaovRUlRkjzh+gDUUInxIYW26ajigMl2aMcuFf4Y/6Mpa
AQUbX7IoIhjdgNBRIBSf+is2LtVm2fVzmLy3sz2RgMEV02UNfYpYoJpIkLzNcMB1
cYTGlpJ6jIZleEXJU31RoSYXse1sR/K/APM8TM8F0susxyOH37PndRcNr5hhU6oE
vlhftuQVXEtgx3t+zsa3azebGqxW5GZLp8w2lwyFTQtzAAmm/J8V3JgnFe4ku54m
GTk2+SJNfBwP/ERj43xjikcajXpOSaqe89XAyUtTzQ+OLMl7/p+ax3QV/gxlooj1
RYNOZMWL3hjwXBv1rdSxuIHk/hebeKCaoVy5SOfynR4hrEZ0lNK+x5GqwMxC5UUn
C5XN5icdY9HttNpkOhwXfy1B8JyR6hmftnGsKkMCQs3v6L7LDPTYtbPAIivaMIIj
X23IO7W19CzHqpFN/jpl
=DSEq
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
