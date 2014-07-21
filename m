Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaGUVHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:07:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40022 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaGUVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:07:06 -0400
Date: Mon, 21 Jul 2014 16:06:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB changes for v3.17
Message-ID: <20140721210650.GD23155@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405956929-10169-1-git-send-email-balbi@ti.com>
 <20140721183450.GA9849@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <20140721183450.GA9849@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 11:34:50AM -0700, Greg KH wrote:
> On Mon, Jul 21, 2014 at 10:35:29AM -0500, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > Here's my big set of patches containing 97 commits. While it looks big =
and
> > all, most commits are just cleanups moving code around, using devm_*, e=
tc.
> >=20
> > I tested these patches on a couple TI platforms and couldn't find any r=
egressions
> > on my setup.
> >=20
> > This tree has also been on linux-next for a while.
> >=20
> > Please consider merging on top of your usb-next branch or let me know i=
f you
> > want anything to change.
> >=20
> > cheers
> >=20
> > The following changes since commit 4c834452aad01531db949414f94f817a8634=
8d59:
> >=20
> >   Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-=
for-v3.17
>=20
> I've now merged and pushed this out.  I did have some merge conflicts in
> these files:
> 	drivers/usb/musb/musb_core.c
> 	drivers/usb/musb/musb_cppi41.c
> 	include/uapi/linux/usb/functionfs.h
>=20
> and I _think_ I resolved them properly, but getting verification of this
> would be great.

your resolution looks correct to me, thank you.

--=20
balbi

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzYDqAAoJEIaOsuA1yqRE918QAJNyOg+1VF5sbfMpNSiSWjtp
O2xYYoaCimbN3Hs5IPprNnP0yIrduQnr85NpUhprtkwyHnEgMU7XXm++EZWM461G
6trf+/e77GxKW/oxyKrhryyrwP8c7jpLWBl6s4hT41kcnIhlYuSj85rxovshPie0
7xR9M7QwxxwCFMbE1qyOqmjYhoIutPQNsM4Q0Zj3fNS12IINkVaRfTT9OaxvSeAS
fEHNFoC2k4FUyVTPDVoT+t6WcyTEnpbeH/RSgL05g70Zyq0SlbraHOylZGiOfDmn
rMELBaLQxVAkOV0W7yQUSt2PJghJbCtSG5waZPjOAVXhzKuncnOJIpEAopZVLOKS
8PZ27WOo4Ht4RVdLf0N6QqSNGA+cwbb52ivkO08jOiOdbgmFRE5GNTrUlE+BBK4L
mhiUHMhvKwkkgx8zzDqxMthkP1ovN/4iL/WblhQoRghlgM6DPbUvFUSbcmOBnqSu
NXh8/zB5yWPINXAJUXifPxvlgxKK+8yZ9eg8ZEKgOQp+E6UQgTrz4eMYLakNOzCz
XWoYFYGBEZlwp79F54f793bwV6XJ2fnCZ80YqitmVgcb6w4ZaZ333QAlZVllojKC
6Vp1/jPa0STIjIsao+JzxI8W1rLwTpTZP4TLhCKNqGpd9FqJHw5VJLlBr4pi/M7N
Qm7LFCnk/DR6J5oxX7e6
=bupR
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
