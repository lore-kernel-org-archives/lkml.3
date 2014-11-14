Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731AbaKNV56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:57:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:46675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655AbaKNV54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:57:56 -0500
Date: Fri, 14 Nov 2014 22:57:50 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141114215749.GA19023@earth.universe>
References: <20141104205117.GA17606@amd>
 <20141106180335.GA21513@earth.universe>
 <20141106225005.GA14002@amd>
 <201411070001.46481@pali>
 <545C6F14.8050303@gmail.com>
 <20141113162420.GB8512@xo-6d-61-c0.localdomain>
 <5465A977.4030605@gmail.com>
 <20141114172008.GB12250@earth.universe>
 <54665E02.8050108@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <54665E02.8050108@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 14, 2014 at 09:54:42PM +0200, Ivaylo Dimitrov wrote:
> On 14.11.2014 19:20, Sebastian Reichel wrote:
> >The patch looks ok. It does not cleanup the cmt-speech driver for
> >mainline usage, but it should work. Before adding this driver to the
> >mainline kernel there should be open source userspace support anyway.
>=20
> I am aware of that(patch not ready), it's one of the reasons this
> patch still sits on gitorious IMO.
>=20
> libcmtspeechdata was opened by Nokia long ago, so I don't understand what
> userspace support (for inclusion of the driver in the mainline kernel that
> is) is needed. see https://gitorious.org/meego-cellular/libcmtspeechdata/=
source/7f8f3ce357513e4849e1bf6d657980a514529c1a:

ah cool. I assumed, that userland stuff is mostly closed.

> REed pulseaudio modules that use cmtspeech will be ready sooner than later
> (I believe in 2-3 monts from now), see on gitorious how fast we progressed
> with -record and -music modules. Sure, -voice module is way more
> complicated, but lots of it is already opensourced, we just need to figure
> out a couple of DSP algorithms(drc, agc, aec, etc) related to call qualit=
y.
> But I don't think the driver should wait for those modules to be REed, th=
ey
> can be used as is even now, in their closed form for testing.

https://gitorious.org/pulseaudio-modules-nemo/jusas-tanuk2-mer-packaging/so=
urce/6ed34611b49c99b007f614d9dff4d58369876345:
https://github.com/nemomobile/pulseaudio-module-cmtspeech-n9xx/commits/mast=
er

It seems there is already cmtspeech code for pulseaudio?

> Unfortunately all my spare time is dedicated to that PA stuff, so
> I simply can't cleanup cmtspeech driver and send a patch for
> upstreaming. (Pavel, what about you?)

If somebody gets audio working with your driver and documents the
steps needed in userland I will take care of upstreaming the driver.

> >Btw. I am aware that this would break existing pulse audio stuff,
> >but wouldn't it make sense to export a V4L2 device instead of the
> >custom /dev/cmt_speech ABI?
>=20
> Not to say that I agree with Pali's reply that working userspace should n=
ot
> be broken just for the sake of it.

Actually the mainline kernel never implemented that interface, so
there is no regression/break and I don't think introducing userspace
ABI's should be done carelessly - especially when there is also a
standardized interface.

> Nokia PA guys did a great job integrating lots of things related to audio
> and honestly, I don't see a reason why should we reinvent the wheel. There
> is lot more behind the scenes than simple PCM streaming (like audio polic=
ies
> and routing, sideband audio, speakers protection, etc) and reiplementing =
all
> this using different API wouldn't worth it IMO.

What has speaker protection to do with the modem interface?
Shouldn't this be two different PA modules?

-- Sebastian

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZnrdAAoJENju1/PIO/qa2nYP/07EkeoVC6/jWuDlQk4R8Z8W
7iHgPlQzDZKoEpkoEhE07NvvtQbqktvedH0MXdt8S5/GHtfk93vsTm6malmQy1dl
ujS4w1bLWX/ujrxMs/IQIXwPFb9ohyMyjwR0Ly8Ws0ifccaAdDVhM/PTmypGpPTI
HqcDIxkRDTnKRLTWGoKyvvqOuc/Pf+l81b5zUPjpRYomeCUiBH2GlYwgs89yg624
vUUuM0K2bU2ElJa3/YdDLkDNyOktKk98kWm/STtBangdP2LYMItr13mVD8sQYndo
Tc8WrnX6uDvZNbj4dJfKRPcadm+CPzgeKmjB46pD1mH+4mk06RbWYdDCPNcyQ4gy
vlMw7TYPcwEguinP34vWSQdK9EFLGJ6i6Y7n2YuaRRvRCUqmWXGSgaHW1tQ52oOi
SsfAa02a1IOqmDXDRpRM3/3KtIJfNiYs1HIrLEVop4mKzWFBiS3F5Db3OmQkUFyv
kD/ZTnSgBVHf6YtcF4VJdjGItd77t6mjhLxW3NHf+vXoFhmcucYJQok56VN7Z5Np
Xc0m20kcl1x+eYGsPpECAPyStwwPzcLfEiEhgCMVx2Z+2pYQrZzjMFsMJhy1Mxe1
UgiXSfcQ/EhPdgJcVH08fywV9H0vTx50QyDvG3HwFXYHS5BqGIBAH6HbQ4qRnqIY
xkxPIJ5saMU9hWWgemEl
=i4H+
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
