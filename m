Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbaDXPEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:04:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45727 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982AbaDXPEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:04:04 -0400
Date: Thu, 24 Apr 2014 10:03:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cwchoi00@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        <gg@slimlogic.co.uk>, Kishon Vijay Abraham I <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv3 1/9] extcon: Add extcon_dev_allocate/free() to control
 the memory of extcon device
Message-ID: <20140424150344.GO26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-2-git-send-email-cw00.choi@samsung.com>
 <20140424144257.GF26661@saruman.home>
 <CAGTfZH0+VCvr=JNbq8kbtC2CDN63k28+oSd__6sb+Qy2tQ4_ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V7BlxAaPrdhzdIM1"
Content-Disposition: inline
In-Reply-To: <CAGTfZH0+VCvr=JNbq8kbtC2CDN63k28+oSd__6sb+Qy2tQ4_ng@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V7BlxAaPrdhzdIM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 24, 2014 at 11:58:29PM +0900, Chanwoo Choi wrote:
> >> +void extcon_dev_free(struct extcon_dev *edev)
> >> +{
> >> +     if (edev)
> >> +             kfree(edev);
> >
> > kfree(NULL) is safe
>=20
> I don't understand about meaning 'kfree(NULL)'.
> Why do I free 'NULL' pointer' instead of 'edev' pointer?

you don't need to check if evdev is valid before calling kfree() on it
because if it happens to be NULL, no cute bunnies will be sacrificed.

--=20
balbi

--V7BlxAaPrdhzdIM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSfQAAoJEIaOsuA1yqREpOkP/3jp5HrlQx7O3Da8QeJy9VHj
R5tNLzpl1HaCNdwHXhOzUkBPFyN++UgShvQjxZKw1rb8w8cUWOB1t0u56dBKgygt
F4GX1njthZASbEQGsCoTUqLIyUMnuQWXifvTaV12I02ui7sATJgDGBSw97VTuezr
G7L/xkifCMQMFLuKDGm2ijvL21G4X357FqmfTe6YqciHSckW+ijUI6lajdbD+s7L
yUOC49u66ac74/uCXknmyK3Nxx8sUznZBrfrH0OalBNcJ3i+spaveV4gwPhJUNqF
0r5Fy6M6Pz71t1cSFMugMzHQ1ta/S2pW4rWd05wIL4Za6/3XgZ5exjorLHdPUCHB
sG3CS69gg0H6RljHvJ7oBP/Ec8xXPJX42nmHvwTJHZMyz06xJnP9vf878YGL/FOE
khSLlnahwkbZFz7lYxEPwobZEMUrGSKNIXXZf13xnJLN/mDPidSrmZqCAmIvyFtA
O5U02aziV7uUb43XGpnPuvMIHFg1zNIXyzalRcXGsFGccPZfXMAymPJN9YoCIciW
d6lM6T9co0UtgcX3sIpB+Ta8Qe45WZ18aoZwixwlJIEDYCKl6gz9Vp0TT1lm+Clw
kaDq4wUT0vbG+2QcnCuaHp4FXslGpSvXhYEPNmnejni6u42u5zwVDbFTflAE+BRO
J7Bq53HdzbbzV43Wmdkc
=SY7P
-----END PGP SIGNATURE-----

--V7BlxAaPrdhzdIM1--
