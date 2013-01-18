Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3ARGtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:49:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3ARGti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:49:38 -0500
Date: Fri, 18 Jan 2013 07:49:31 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH v2] pwm: pwm-tiehrpwm: Update the clock handling of
 pwm-tiehrpwm driver
Message-ID: <20130118064931.GA17790@avionic-0098.adnet.avionic-design.de>
References: <1357823126-19333-1-git-send-email-avinashphilip@ti.com>
 <20130117155218.GA23117@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3EA5F43D@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA5F43D@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7FXm4UIzUbRem6wVxcrmCOgSsQCLkgOsfqzpPr3Q1jh
 znSLUcNQZvPSNUs+9PbwW7Do3LcHkbPhvtzoGTgGm0g2GKT1No
 a/YgJQPId4Ckhj6BuAa+Pp8WSzf2LWia51zpzSUC7Tcf/4URl6
 +l+60VUNM2VIp7A8JdEQiwK9BOC1SgnyVGP09CECLqqJC86hDG
 qqMWu62TZW7hLxT0+573CRpVGxbeddQLt5vcmDn1OtVF3cQRdk
 n+zkaZzOq3JAv554iOATABKn8VZqM7S9WXf4QhftAoP6FcflQD
 QTwjzMf1t7cbXVJiTNfMBZe8CRd9ViwHAwgugh2snRxgvFiU1o
 sFv0Uqo7oB2I+V/lKS3JVfv7sTwNfC5S6dIfr0u9MCUb3rIdVn
 VABnqaZA7prSxuKvS0ZBd56HsCBp2S6fLI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 04:18:27AM +0000, Philip, Avinash wrote:
> On Thu, Jan 17, 2013 at 21:22:18, Thierry Reding wrote:
> > On Thu, Jan 10, 2013 at 06:35:26PM +0530, Philip Avinash wrote:
> > > From: "Philip, Avinash" <avinashphilip@ti.com>
> > >=20
> > > The clock framework has changed and it's now better to invoke
> > > clock_prepare_enable() and clk_disable_unprepare() rather than the
> > > legacy clk_enable() and clk_disable() calls. This patch converts the
> > > pwm-tiehrpwm driver to the new framework.
> > >=20
> > > Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> > > ---
> > > Changes Since v1:
> > > 	- Check the return value of TBCLK enable in .pwm_enable()
> > >=20
> > > In 3.8-rc1, common clock frame work support added to AM335x.
> > >=20
> > >  drivers/pwm/pwm-tiehrpwm.c |   10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> >=20
> > I had applied this to my for-next branch, but reading the commit message
> > again it would seem that this should actually go into 3.8, right?
>=20
> Common clock framework support added for am335x in 3.8 only, still EHRPWM
> tbclk not present in clock tree. I expect this to be in 3.9. So this patch
> also requires to be in 3.9 only.

Okay, I'll leave it in my for-next branch then, which gets merged into
linux-next and will go into 3.9.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+PB6AAoJEN0jrNd/PrOhiCUP/AhVxZWjyi9HWOANPYDcqP0m
L1OInFX7XZ+LSahnyfkpgbszub/tEvZnOwD5CdsEq3V9nVGNB/Y46the0tFwhJVR
iXbVNnnRAK2r3N7avoJX/TAKg0DDCBvkU3UOXEkx5M7vooZ5Qf36rmw5BbAZ7uaf
pjbTmCrLzAvlbPYwZ+0Vk9MZGyn1oetmkTiaDPhswfkKkwBZX/79b38BzsJR5Yye
dGEl6aKsrJbl7s1mH/Q0DkMFoEhXNYme1beKNwrerdIu5aNgd70V1sKLOeirzSzQ
iINZMY2kZRl0CNOWw6b8YzYs7enLbawJtVQQxq7zQ5KeZy4UeahXYnRX/Hzjqx7w
DZjbPhzC1XPaF3HuCW4NCGmmQHjJJ4vZIo10J0+O+txh8gksUqi8fN/4apLVZ932
GxRmHfJ/lmNuKEGE2sKNKmOYxupspbWvvQ27qZKVyR1SEPBCESxhVMqYJfTRr7HZ
a1LffZ0HcS57X6X9g8/Xmh1njOcKZ8R0stmJ5Jt9zEOK6W6OkZBliYIRPp86BRN9
zhLP0pExPq7C8gc/HKs+3OhfxDKPzAux1SERXZ8remzdHbwXw1Q0ug34RGwWk0Lg
cUohta+Ej55HHFRXDse2EHhFBETvX9DBPNx0nclHehZ6vDrCjL5PPpj8w9Iztxwb
lSpFMTPzUXFfJu22EUcB
=gE0p
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
