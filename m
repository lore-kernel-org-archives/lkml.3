Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3INMGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:06:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50220 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754729Ab3INMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:06:01 -0400
Date: Sat, 14 Sep 2013 14:05:57 +0200
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cinifr <cinifr@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "coosty@163.com" <coosty@163.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/4] Add physical count arch timer support for
 clocksource in ARMv7.
Message-ID: <20130914120557.GB2746@lukather>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
 <1378968687-8200-4-git-send-email-cinifr@gmail.com>
 <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
 <CAK3cCBwu4somtfc9J1ZDVcC-iYD1qDJwSWzWeOomTqY9tQA2kg@mail.gmail.com>
 <5231EE43.5090900@arm.com>
 <CAK3cCBzr8_LTYarZDgPYZY7_-5Qco_Qw+ACi=c2uOrn7MqwkBg@mail.gmail.com>
 <5232DB49.4050701@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rErXCrER28iYcLtG"
Content-Disposition: inline
In-Reply-To: <5232DB49.4050701@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rErXCrER28iYcLtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marc, Fan,

On Fri, Sep 13, 2013 at 10:30:49AM +0100, Marc Zyngier wrote:
> On 13/09/13 09:49, cinifr wrote:
> > On 13 September 2013 00:39, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > I am   wondering   what is the principle between kernel and bootload?
> > What should be done in bootloader and what should be done in kernel?
> > As you said, If kernel boot from hyp,  Kernel can set  CNTVOFF to zero
> > directly, does we add the code to set CNTVOFF in kernel?  But, if
> > kernel boot from PL1 NS=3D0,  Does kernel  need to switch hyp mode to
> > set  CNTVOFF and return  PL1 NS=3D0 mode? Or,kernel dont care it because
> > kernel   believe bootloader have set CNTVOFF  before?
>=20
> In an ideal world, the bootloader should set CNTVOFF to zero. The fact
> that the kernel does it too when booted in HYP mode is to preserve
> itself from from broken bootloaders.
>=20
> CNTVOFF can only be setup from either HYP or Secure Monitor mode with
> SCR.NS =3D=3D 1, so if you run your kernel in secure mode, it is always b=
est
> to do it in the bootloader.

What would happen exactly if a kernel expects CNTVOFF to be set to 0,
and that your bootloader don't set it?

=46rom what you're saying, it's will be set by the kernel if it's booted
in hypervisor mode, but what if it's not?

The ARM documentation says that the CNTVOFF register will hold an
undefined value, how would that affect the kernel?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--rErXCrER28iYcLtG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSNFElAAoJEBx+YmzsjxAg5ckP/1KwGFMNzU3B/0TFgw8BDfv9
G4tZyZcz14Jk6CDpJIaVFTfUdsLT72yaRd7g/QC5eCEumYTwuRUGa0B57XxU10hH
M9ZstXToKRDG1holU4LWXhLgPJ/os9lNPJ4tRO1mpkw65F046lzb+MVevdiX2mRv
EBAcYFkYLXngLj83bfnpZj/wT9FFyferXrdIfY5fSQQ+C1M3ffI8oixZJF8gdH1l
4teuvZzlz+AKnpZWw8Dm9LxfH369ulMlUhnuCpqRhNDrkTyLGFCWmwChW3btuhtn
zlwfawpKGGC32pJtk18tfxZiJkcwboiGLdCadvAHw0KN+idEhvXAng306JKWHLL8
FidEFop8sdtaK036ZnYrSvkxbJYthglZxTb0OdyaGddW159qEbXVE4APHRSujSvc
tpl6EZOMUPBSp/7Z1JpvfIrI33quQJaR+vkMAzgvEnEa21ohI+P8JbZJvLEkx1PF
pB3Oq6TAc2uVg6VJHwVr1Tt4XCLewJk82xngFrOoe8IEWVMuiuAKjCPBVr7hNye3
881Y0hZYBYSw6mvyAFfaxl/wEiELsR2HVkpkVJVXOWAWOKyjbWXlmeYZwdra0Cvm
e2V7XVOxvntmqREp8y8HuK3ZQijOewuxcChoALTMj3+8gIXWKGSCKDoE4D9rTC24
7Ug/kif2W6JranpZmYvx
=ExLi
-----END PGP SIGNATURE-----

--rErXCrER28iYcLtG--
