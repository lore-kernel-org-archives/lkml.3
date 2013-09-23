Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3IWSee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:34:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57808 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753848Ab3IWSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:34:33 -0400
Date: Mon, 23 Sep 2013 21:34:30 +0300
From: "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>
To: cinifr <cinifr@gmail.com>
Cc: Ian Campbell <ijc@hellion.org.uk>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "coosty@163.com" <coosty@163.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130923183430.GT2779@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
 <1379861045.30708.22.camel@dagon.hellion.org.uk>
 <CAK3cCBzMXdeeSPC-OpWcHAuef=ocpy5n0=Fc2yBECPnU=2OTXw@mail.gmail.com>
 <1379920736.30708.26.camel@dagon.hellion.org.uk>
 <CAK3cCByGeAK2H83bP0wy=kC_+kj4Q8cFHPQ1gYUJ=uv4gs-T-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="flpRHSNNLnUanxKW"
Content-Disposition: inline
In-Reply-To: <CAK3cCByGeAK2H83bP0wy=kC_+kj4Q8cFHPQ1gYUJ=uv4gs-T-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--flpRHSNNLnUanxKW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 23, 2013 at 10:43:55PM +0800, cinifr wrote:
> > In which case this kernel patch needs instead to speak the bootloader
> > wakeup protocol instead of speaking to the h/w directly like you've done
> > here, right?
> >
> > Or is it possible for the bootloader to set these things up and then put
> > the CPU back to sleep such that it both retains any settings and is
> > wakable by this patch? This code contains core resets and power control,
> > which makes me suspect not.
>=20
> And I think secondary cpus  remains setting after h/w boot.
> >> > Wouldn't it be better to do all this stuff in the bootloader and
> >> either
> >> > implement PSCI or have the bootloader do the traditional holding pen
> >> and
> >> > mbox address thing?
> Uboot doesnot support PSCI, it use  traditional holding pen for sunxi
> platform now.
>=20
> >> >
> >> I have modified uboot to set cntfrq and cntvoff in all smp cpus,and it
> >> works well. I guess kernel should believe all cpu should be all same
> >> when kernel boot. Bootloader should do it to ensure that.
> >
> > Yes, I think all CPUs must be in the same state at boot.
> >
> > But if you've done all that then what is this patch for?
> >
> > Do you have links to your u-boot patches?
> >
> > Ian.
> Yes, This is my patch for uboot.
> My working uboot code is in https://github.com/linux-sunxi/u-boot-sunxi.g=
it
> Note this is only test patch. I have not commit it  formally for uboot.

Please do so. I'd like very much to avoid ending up in a situation where
we would break the mainline kernel for the A20, without any bootloader
we can point the users to to fix the issues.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--flpRHSNNLnUanxKW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQIm2AAoJEBx+YmzsjxAgxrMP/2hq+ZduVfDCKGUc00zA/+yr
73C+EzlOB8SG6VlFP1zTYNJJKR924ZKI5L7KqvNAIoUg1pLOlST44rRQp99ahYZU
3Fc7ngoTwmhVEX6+bBhjL9QVp/vPxjVybtdd+grBrfNLlwVwLKFyFwDg2PNG7S6J
behXrqU6wfhxwG1eeG/O4SJBrCMV/86qu+66NZnuwFdlb9XRqUPe3OU+vfAnOxgf
FEuz4ALx1nQhZvltZFXE7zj8xj2/y9n8aurjCJxbLhYz1ZCYxhEQgKeUhPjorgPc
6n7LRyzFsVzSVIFHmhls/2VBGQfbHT/xc5fsh3qVgr+NYf/Wfxtb1wWRwYlLsl7H
yTE89NlQkOw+6bCPs2UnB+kScXuj28W1Ik6KLV1XGGstANHjdYPU3ye1VM8eT3mG
dAY52EBkWBd6tb9OJKISXotBmwXxrCxX6+jht1OrkBZXrC36eA5KoW/krhZcBp2U
TKLO1uitl7h5TsC4eo/O6efW8p3gEs7rgMixMvtOx07ipenVPhx4XbJKMkGP2rIL
9DeoSUYEEs1SBqqrt1UFJrJnHECXysAvV+3EfliuGLIPhVtTmdtgKpv6FV1MJ0xB
pLv67Y8715PF6YJwnQ/Qai17kkuTLQgb3BEXkLbw8UjdRkmJ5ON050oMphwPOZ8h
Q++xb3rV+HoUne0gVAuV
=N2/Q
-----END PGP SIGNATURE-----

--flpRHSNNLnUanxKW--
