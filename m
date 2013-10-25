Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3JYIfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:35:31 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:56204 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3JYIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:35:29 -0400
Date: Fri, 25 Oct 2013 10:35:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
Message-ID: <20131025083525.GF19622@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f61P+fpdnY2FZS1u"
Content-Disposition: inline
In-Reply-To: <5269FB5E.6010901@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f61P+fpdnY2FZS1u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2013 at 10:02:22PM -0700, Guenter Roeck wrote:
> On 10/24/2013 09:31 AM, Thierry Reding wrote:
> >Hi all,
> >
> >I've uploaded today's linux-next tree to the master branch of the
> >repository below:
> >
> >         git://gitorious.org/thierryreding/linux-next.git
> >
> >A next-20131024 tag is also provided for convenience.
> >
> >Quite a few new conflicts. Some of them non-trivial. I've fixed another
> >set of build failures, so 32-bit and 64-bit allmodconfigs build fine on
> >x86. ARM and x86 default configurations also build fine. PowerPC is in
> >pretty bad shape, mostly due to some OF header rework going on.
> >
>=20
> Hmm ... I see
>=20
> Building arm:defconfig ... failed
> --------------
> Error log:
> drivers/built-in.o: In function `mmc_gpio_request_cd':
> clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_request_one'
> make: *** [vmlinux] Error 1
>=20
> Otherwise pretty much the same as yesterday, with a build log of
> 	total: 110 pass: 88 skipped: 4 fail: 18
>=20
> This is with "v3.12-rc5-7941-g765f88c".

Yeah, I saw the devm_gpio_request_one() errors too. They happened for 3
boards on ARM I think. Must have forgotten to update the summary email.
I'll see if I can come up with a patch to fix the GPIO related build
failures, or at least report it to LinusW or Alexandre.

Thierry

--f61P+fpdnY2FZS1u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSai1NAAoJEN0jrNd/PrOhcsQP/3GkaH1ghD+QH1OAex6Gw10/
nNwJnB5ufcm2eU3Cw2D8qQtXLD614m89bUJ+WHsQ0ll0PXgJ+cXwPdHzt6eiEjfO
you5rQiN/wCBUp8nMv7Pv+JkngBEBw5fG9hPfa/IKb64kH8BVxA4QvUa7ismJA2Y
rcIQdeHUhxtRrkVilfvl4QaAFYCw96jOcpAH/tlsGiG/SyFNHlmai6uS/9W2PIIl
7frq/xJRRsdYkMW8hAY9pSwS8K0ulcywTZ+p+Gla9bgTIAzMqBLPAOnKGSdWvzgi
vIbjOvGAB3rvwK8VagbfGB9IWXKoqCXpYmGqBU8WaupDvxpGeQsRcv13HuXvrQCI
6q1riCVJlQmI1Qion4Vd6ZpV1p/eOscz92TDGLOfEngH4HNHs8d8hiZnN0QdLDFF
NNMsIsy1RRixpTgKaYiraAZnIR0TCWMjbVNZvvuGZJocYzRCw3znopOMd/Kmb8Me
ln6Y1c9TMQ7ItQBlI/IcJVBc+N7/ZmgevE8mx9MYSs4a6eNI7dOod5Ok5IOx0afZ
4qXCMYjz8J/XS11gmiBvnDOBXcHQd5BO/f4lqm6uXm8Vfu0krT7iIx54t3XkGlPk
BU7t5VSpOcY1I08JXRon8TsbxZq+XAYq2lnPhhYnwfTU87ubOWuaDVrJO7zzlXnF
RAwUNgTNviTTijl05Jr7
=6MLN
-----END PGP SIGNATURE-----

--f61P+fpdnY2FZS1u--
