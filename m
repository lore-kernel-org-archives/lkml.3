Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3JYNff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:35:35 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54912 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3JYNfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:35:33 -0400
Date: Fri, 25 Oct 2013 15:35:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 24
Message-ID: <20131025133512.GA1551@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <5269FB5E.6010901@roeck-us.net>
 <20131025083525.GF19622@ulmo.nvidia.com>
 <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 06:16:02AM -0700, Olof Johansson wrote:
> On Fri, Oct 25, 2013 at 1:35 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Thu, Oct 24, 2013 at 10:02:22PM -0700, Guenter Roeck wrote:
> >> On 10/24/2013 09:31 AM, Thierry Reding wrote:
> >> >Hi all,
> >> >
> >> >I've uploaded today's linux-next tree to the master branch of the
> >> >repository below:
> >> >
> >> >         git://gitorious.org/thierryreding/linux-next.git
> >> >
> >> >A next-20131024 tag is also provided for convenience.
> >> >
> >> >Quite a few new conflicts. Some of them non-trivial. I've fixed anoth=
er
> >> >set of build failures, so 32-bit and 64-bit allmodconfigs build fine =
on
> >> >x86. ARM and x86 default configurations also build fine. PowerPC is in
> >> >pretty bad shape, mostly due to some OF header rework going on.
> >> >
> >>
> >> Hmm ... I see
> >>
> >> Building arm:defconfig ... failed
> >> --------------
> >> Error log:
> >> drivers/built-in.o: In function `mmc_gpio_request_cd':
> >> clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_request_on=
e'
> >> make: *** [vmlinux] Error 1
> >>
> >> Otherwise pretty much the same as yesterday, with a build log of
> >>       total: 110 pass: 88 skipped: 4 fail: 18
> >>
> >> This is with "v3.12-rc5-7941-g765f88c".
> >
> > Yeah, I saw the devm_gpio_request_one() errors too. They happened for 3
> > boards on ARM I think. Must have forgotten to update the summary email.
> > I'll see if I can come up with a patch to fix the GPIO related build
> > failures, or at least report it to LinusW or Alexandre.
>=20
> Hmm.
>=20
> Please don't apply fixes like these directly to your tree, keep the
> broken parts (or drop the tree that introduced it). It makes the
> process of getting the fixes in where they really have to go much more
> error prone, since there's no way to track whether they have landed in
> the right place yet or not.

I've found that fixing one build error often subsequent build failures,
which would go unnoticed if I dropped the trees or let the breakage
unfixed.

Except for very few occasions I've immediately sent out patches to the
respective subsystem maintainers, so they should've gotten picked up.
What's the difference if I do it as part of linux-next to if somebody
does it outside? At least this way they are part of the linux-next tree
so if I create the next one and cherry-pick the patches and they still
apply I can be reasonably sure that they haven't landed in the right
place yet.

Thierry

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSanOQAAoJEN0jrNd/PrOhrOYP/14ePCPYkpciNSfAu6RZ3sBA
gsrdthpqll+iDvFnpRV1odNLnRTdTFIFUNvYo7b26p0cCO/bChEI6w0JJWzPHx/i
+ZXpUyorID3Ekw6FW+mMdqhWv+NiGwLIr/X/LCa/E4WCFvGOqnuWlEBuskMiHHPj
XGEx0IHCQLJzCAqHVaAu+PVPc0hw2AJ7t0zNXZYrkUWJe5Xulbasdhx6xGtMJ06k
70uLvFX3gI2Dl4wmdPtJpbma3Nk4hE77HCO7/+hikNbviVcL2FWA3mO18+tTgPWo
WTS+wWJjd62T6vvFnyV5ND8NAvOWy5kcZ1xc1q1CbKgcVGEKBVPGJCqNLaqpITi2
36vltI1ATZ84/pZIOd6wQoU7Jn7Ud1tdPYKFrTVzNQsTEMy3n4WdqbwvwDys+Xp4
Yg1LEWjeYt/UjjUXxJutvk1AQZnbMUk+toOdK3VgUVwhowfFuoh38VJcIeKK+ZyA
BSuzkf5PPlmp0jqL9tDYyhtkPyexxvVswYsdX8MKXccVys5JL/7nknLT15WK21Zg
Cms45gntTfL8nUvu9a00pk+xmP+Tl4qpZ+2xyymyqh+iyyWh9EZlly5Pq8husA4n
dWi8JoYh9CLRj+XRsTotN1kGrbO3Ceamg81j4zXsnptdUXspdSvX9cRu9fhpbN1A
6FSLKUlExniuf3MP1i5+
=FuEZ
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
