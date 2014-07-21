Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaGUPE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:04:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35510 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaGUPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:04:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Cc: Tony Lindgren <tony@atomide.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        linux-kernel@vger.kernel.org, marek.belisko@gmail.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Date: Mon, 21 Jul 2014 17:04:57 +0200
Message-ID: <2288457.9ZfWAQMUao@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20131216234829.GC29284@saruman.home>
References: <1387209225-11520-1-git-send-email-kishon@ti.com> <20131216223826.GG26293@atomide.com> <20131216234829.GC29284@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1568003.8yIXfBolcA"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1568003.8yIXfBolcA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Felipe,

What happened to these two patches ?

On Monday 16 December 2013 17:48:29 Felipe Balbi wrote:
> On Mon, Dec 16, 2013 at 02:38:27PM -0800, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [131216 13:31]:
> > > On Mon, Dec 16, 2013 at 09:23:43PM +0530, Kishon Vijay Abraham I =
wrote:
> > > > After the platform devices are created using PLATFORM_DEVID_AUT=
O, the
> > > > device names given in usb_bind_phy (in board file) does not mat=
ch with
> > > > the actual device name causing the USB PHY library not to retur=
n the
> > > > PHY reference when the MUSB controller request for the PHY in t=
he
> > > > non-dt boot case.
> > > > So removed creating platform devices using PLATFORM_DEVID_AUTO =
in
> > > > omap2430.c.
> > > >=20
> > > > Did enumeration testing in omap3 beagle.
> > > >=20
> > > > Changes from v2:
> > > > * Fixed the commit log
> > > >=20
> > > > Changes from v1:
> > > > * refreshed to the latested mainline kernel
> > > > * added musb_put_id from omap2430 remove.
> > >=20
> > > Tony, how do you want to handle this ? You want me to provide you=
 a
> > > branch which we both merge ?
> >=20
> > Yes that would be great thanks. For the mach-omap2 touching parts:
> >=20
> > Acked-by: Tony Lindgren <tony@atomide.com>
>=20
> Here it is, let me know if you prefer a signed tag:
>=20
> The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d7=
9e42ae:
>=20
>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> usb-phy-binding-omap3
>=20
> for you to fetch changes up to 23ada3130cf4e56acb86fdff4c26113188d52d=
18:
>=20
>   arm: omap: remove *.auto* from device names given in usb_bind_phy
> (2013-12-16 17:44:43 -0600)
>=20
> ----------------------------------------------------------------
> Kishon Vijay Abraham I (2):
>       usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c=

>       arm: omap: remove *.auto* from device names given in usb_bind_p=
hy
>=20
>  arch/arm/mach-omap2/board-2430sdp.c        |  2 +-
>  arch/arm/mach-omap2/board-3430sdp.c        |  2 +-
>  arch/arm/mach-omap2/board-cm-t35.c         |  2 +-
>  arch/arm/mach-omap2/board-devkit8000.c     |  2 +-
>  arch/arm/mach-omap2/board-ldp.c            |  2 +-
>  arch/arm/mach-omap2/board-omap3beagle.c    |  2 +-
>  arch/arm/mach-omap2/board-omap3logic.c     |  2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c   |  2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c   |  2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c |  2 +-
>  arch/arm/mach-omap2/board-overo.c          |  2 +-
>  arch/arm/mach-omap2/board-rx51.c           |  2 +-
>  drivers/usb/musb/musb_core.c               | 31 ++++++++++++++++++++=
++++++-
>  drivers/usb/musb/musb_core.h               |  2 ++
>  drivers/usb/musb/omap2430.c                | 19 ++++++++++++++++--
>  15 files changed, 61 insertions(+), 15 deletions(-)

=2D-=20
Regards,

Laurent Pinchart

--nextPart1568003.8yIXfBolcA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJTzSwgAAoJEIkPb2GL7hl1mvoIALGOCOeGoY9cIxYPAbfayoQA
gdkYM9tflc6aHA5aUKl9EKfNhpGLrfyVkaXURnY74Ha2qz3yIuIuV4v/YuABi+zB
AHz2AmuXV3dAwFm3FsYFWFuSeyb90BH8UWfL36hm18wZcoMzvBIP+w642DV0Dfna
wkIsSle8NVOfAUjQLfVBbkw95wl26DWkhcCiIewPP1UXFmKV25wewTt0U2rzLivf
8f+gzeuH9+vFfYCHyd6YDaDHtHHNXK5dKEGvx2g5NfvI6Z/h104iZs4r6k0SElQL
+71zg4PZjLS0dbOv1dVTSqgg6NKKOwhXytNK4ycLo/j/A8KdXg+GRlC6PN/dPz4=
=+8GO
-----END PGP SIGNATURE-----

--nextPart1568003.8yIXfBolcA--

